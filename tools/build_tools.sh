#!/bin/bash
##  Copyright 2022-present Contributors to the pipeline project.
##  SPDX-License-Identifier: BSD-3-Clause
##  https://github.com/mikaelsundell/pipeline

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
machine_arch=$(uname -m)
macos_version=$(sw_vers -productVersion)
major_version=$(echo "$macos_version" | cut -d '.' -f 1)
cmd_name="pipelinetools"
pkg_name="pipelinetools"

# signing
sign_code=OFF
developerid_identity=""
teamid_identity=""
apple_id=""
notary_password=""

# permissions
permission_app() {
    local bundle_path="$1"
    find "$bundle_path" -type f \( -name "*.dylib" -o -name "*.so" -o -name "*.bundle" -o -name "*.framework" -o -perm +111 \) | while read -r file; do
        echo "setting permissions for $file..."
        chmod o+r "$file"
    done
}

# check signing
parse_args() {
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --target=*) 
                major_version="${1#*=}" ;;
            --sign)
                sign_code=ON ;;
            *)
                build_type="$1" # save it in build_type if it's not a recognized flag
                ;;
        esac
        shift
    done
}
parse_args "$@"

# target
if [ -z "$major_version" ]; then
    macos_version=$(sw_vers -productVersion)
    major_version=$(echo "$macos_version" | cut -d '.' -f 1)
fi
export MACOSX_DEPLOYMENT_TARGET=$major_version
export CMAKE_OSX_DEPLOYMENT_TARGET=$major_version

# exit on error
set -e 

# clear
clear

# build type
if [ "$build_type" != "debug" ] && [ "$build_type" != "release" ]; then
    echo "invalid build type: $build_type (use 'debug' or 'release')"
    exit 1
fi

echo "Building $pkg_name for $build_type"
echo "---------------------------------"

# signing
if [ "$sign_code" == "ON" ]; then
    read -p "enter Developer ID certificate identity [${DEVELOPERID_IDENTITY:-}]: " input_developerid_identity
    developerid_identity=${input_developerid_identity:-${DEVELOPERID_IDENTITY:-}}

    if [[ "$developerid_identity" != *"Developer ID"* ]]; then
        echo "developer ID certificate identity must contain 'Developer ID', required for adhoc distribution."
        exit 1
    fi

    team_id=$(echo "$developerid_identity" | grep -oE '\([A-Za-z0-9]{10}\)' | tr -d '()')

    if [[ -z "$team_id" ]]; then
        echo "failed to extract Team ID from Developer ID certificate identity."
        exit 1
    fi
    echo "team ID extracted: $team_id"

    read -p "enter your Apple ID [${APPLE_ID:-}]: " input_apple_id
    apple_id=${input_apple_id:-${APPLE_ID:-}}

    while [[ ! "$apple_id" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; do
        echo "invalid email format. Please enter a valid Apple ID."
        read -p "enter your Apple ID [${APPLE_ID:-}]: " input_apple_id
        apple_id=${input_apple_id:-${APPLE_ID:-}}
    done

    read -s -p "enter your app-specific password: " input_app_password
    echo ""
    app_password=${input_app_password:-${NOTARY_PASSWORD:-}}
    cleaned_password=$(echo "$app_password" | tr -d '-')

    while [[ ${#cleaned_password} -ne 16 ]]; do
        echo "invalid password length. App-specific passwords are 16 characters without counting dashes."
        read -s -p "enter your app-specific password: " input_app_password
        echo ""
        app_password=${input_app_password:-${NOTARY_PASSWORD:-}}
        cleaned_password=$(echo "$app_password" | tr -d '-')
    done

    echo "valid Developer ID, Apple ID, and app-specific password provided."
fi

# build tools
build_tools() {
    local build_type="$1"

    # cmake
    export PATH=$PATH:/Applications/CMake.app/Contents/bin &&

    # script dir
    cd "$script_dir"

    # clean dir
    build_dir="$script_dir/${pkg_name}_macOS${major_version}_${machine_arch}_${build_type}"
    if [ -d "$build_dir" ]; then
        rm -rf "$build_dir"
    fi

    # build dir
    mkdir -p "$build_dir"
    cd "$build_dir"

    # thirdparty dir
    if ! [ -d "$THIRDPARTY_DIR" ]; then
        echo "could not find 3rdparty project in: $THIRDPARTY_DIR"
        exit 1
    fi

    bin_matches=()
    deploy_files=()

    # pipeline
    pipelinebin="$PIPELINE_DIR/bin"
    bin_patterns=("colorpalette" "colortool" "it8tool" "logctool" "rawtoaces" "symmetrytool" "texttool")    
    dir_patterns=("resources" "fonts" "presets")

    for pattern in "${bin_patterns[@]}"; do
        matches=$(find "$pipelinebin" -type f -name "$pattern")
        if [ -n "$matches" ]; then
            while IFS= read -r file; do
                bin_matches+=("$file")
            done <<< "$matches"
        fi
    done

    for dir in "${dir_patterns[@]}"; do
        matches=$(find "$pipelinebin" -type d -name "$dir")
        if [ -n "$matches" ]; then
            while IFS= read -r dir; do
                deploy_files+=("$dir")
            done <<< "$matches"
        fi
    done

    # thirdparty
    thirdpartybin="$THIRDPARTY_DIR/bin"
    bin_patterns=("dcraw*" "exr*" "ff*" "idiff" "iinfo" "igrep" "oiiotool")  

    for pattern in "${bin_patterns[@]}"; do
        matches=$(find "$thirdpartybin" -type f -name "$pattern")
        if [ -n "$matches" ]; then
            while IFS= read -r file; do
                bin_matches+=("$file")
            done <<< "$matches"
        fi
    done

    deploy_files+=("${bin_matches[@]}")

    # pipeline tools dir
    pipelinetools_dir="${build_dir}/Pipeline tools"
    mkdir -p "$pipelinetools_dir"

    for path in "${deploy_files[@]}"; do
        if [ -f "$path" ]; then
            echo "copy file: $path to build."
            cp "$path" "$pipelinetools_dir"
            if [ "$sign_code" == "ON" ]; then
                if [ -n "$developerid_identity" ]; then
                    echo "deploy file and sign"
                    "$script_dir/macdeploy.sh" -e "$path" -p "$pipelinetools_dir" -d "$THIRDPARTY_DIR/lib,$PIPELINE_DIR/lib" -i "$developerid_identity"
                else 
                    echo "developer ID identity must be set for adhoc distribution, sign will be skipped."
                fi
            else
                echo "deploy file"
                "$script_dir/macdeploy.sh" -e "$path" -p "$pipelinetools_dir" -d "$THIRDPARTY_DIR/lib"
            fi

        elif [ -d "$path" ]; then
            echo "copy dir: $path to build."
            cp -fR "$path" "$pipelinetools_dir"
        else
            echo "$path is neither a file nor a directory (might not exist)."
        fi
    done

    # copy diskimage
    diskimage_dir="${script_dir}/diskimage"
    cp "$diskimage_dir/3rdparty LICENSE" "$build_dir"
    cp "$diskimage_dir/Pipeline project GITHUB.webloc" "$build_dir"

    # to create a DS_Store.in file mount the dmg as writeable
    # hdiutil convert in.dmg -format UDRW -o out.dmg
    # make the edits, icons, layout and copy the .DS_Store file to the
    # diskimage dir.
    cp "$diskimage_dir/DS_Store.in" "$build_dir/.DS_Store"

    pkg_file="${build_dir}.dmg"
    if [ -f "$pkg_file" ]; then
        rm -f "$pkg_file"
    fi

    hdiutil create -volname "$(basename "$build_dir")" -srcfolder "$build_dir" -ov -format UDZO "$pkg_file"
    echo "DMG created: $pkg_file"

    if [ "$sign_code" == "ON" ]; then
        codesign --force --deep --sign "$developerid_identity" --timestamp --options runtime "$pkg_file"
        echo "DMG signed: $pkg_file"

        echo "submitting DMG for notarization..."
        xcrun notarytool submit "$pkg_file" \
            --apple-id "$apple_id" \
            --password "$app_password" \
            --team-id "$team_id" \
            --wait

        echo "stapling notarization ticket..."
        xcrun stapler staple "$pkg_file"

        echo "validating stapling..."
        xcrun stapler validate "$pkg_file"

        echo "DMG notarized and stapled successfully: $pkg_file"
    fi
}

build_tools "$build_type"
