#!/bin/bash
##  Copyright 2022-present Contributors to the 3rdparty project.
##  SPDX-License-Identifier: BSD-3-Clause
##  https://github.com/mikaelsundell/pipeline 

use_xcode=""

parse_args() {
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --xcode) use_xcode=1; shift ;;
            *) shift ;;
        esac
    done
}
parse_args "$@"

# build project
build_project() {
    local repo_url="$1"
    local repo_branch="$2"
    local project_dir="$3"
    local project_config="$4"
    local install_dir="$5"
    local build_type="$6"

    if [ -n "$use_xcode" ]; then
        project_dir="$project_dir"
    fi

    if [ -d "$project_dir" ]; then
        echo "Project dir $project_dir already exists, will be skipped"
        return 1
    fi

    echo "Cloning $project_dir from repository"
    git clone --branch "$repo_branch" "$repo_url" "$project_dir"
    if [ $? -ne 0 ]; then
        echo "Failed to clone repository"
        return 1
    fi

    local build_dir="${project_dir}/build"
    mkdir -p "$build_dir"
    cd "$build_dir" || return

    echo "Configuring project with cmake"
    local cmake_module_path=""
    if [ -d "${project_dir}/modules" ]; then
        cmake_module_path="-DCMAKE_MODULE_PATH=${project_dir}/modules"
    fi

    local cmake_xcode=""
    if [ -n "$use_xcode" ]; then
        cmake_xcode="-GXcode"
    fi

    cmake .. \
        -DCMAKE_INSTALL_PREFIX=$install_dir \
        -DCMAKE_PREFIX_PATH="$THIRDPARTY_DIR;$install_dir" \
        $project_config \
        $cmake_module_path $cmake_xcode

    if [ $? -ne 0 ]; then
        echo "CMake configuration failed"
        return 1
    fi

    echo "Building and installing project"
    if [ -n "$use_xcode" ]; then
        xcode_type=$build_type
        if [[ "$xcode_type" == "debug" ]]; then
            xcode_type="Debug"
        elif [[ "$xcode_type" == "release" ]]; then
            xcode_type="Release"
        fi
        cmake --build $build_dir --config $xcode_type # we skip install from xcode, only for development
    else
        cmake --build $build_dir --config $build_type --target install
    fi
    
    if [ $? -ne 0 ]; then
        echo "Build failed."
        return 1
    fi

    echo "Build completed successfully."
    return 0
}

if [ -n "$PIPELINE_DIR" ]; then
    pipeline_dir="$PIPELINE_DIR"
else
    echo "could not find PIPELINE_DIR, make sure it's defined"
    exit 1
fi

if [ -n "$THIRDPARTY_DIR" ]; then
    pipeline_dir="$THIRDPARTY_DIR"
else
    echo "could not find THIRDPARTY_DIR, make sure it's defined"
    exit 1
fi

# projects
projects_dir="$PIPELINE_DIR/projects"
install_dir="$PIPELINE_DIR"
project_names=(
    "rawtoaces"
    "brawtool" 
    "cineontool"
    "colorpalette"
    "colortool"
    "photographic-dctls"
    "logctool"
    "symmetrytool"
    "texttool"
)
    
project_repos=(
    "https://github.com/mikaelsundell/rawtoaces"
    "https://github.com/mikaelsundell/brawtool.git"
    "https://github.com/mikaelsundell/cineontool.git"
    "https://github.com/mikaelsundell/colorpalette.git"
    "https://github.com/mikaelsundell/colortool.git"
    "https://github.com/mikaelsundell/photographic-dctls"
    "https://github.com/mikaelsundell/logctool.git"
    "https://github.com/mikaelsundell/spectraltool.git"
    "https://github.com/mikaelsundell/symmetrytool.git"
    "https://github.com/mikaelsundell/texttool.git"
)

project_branches=(
    "ms-250830"
    "master"
    "master"
    "master"
    "master"
    "master"
    "master"
    "master"
    "master"
    "master"
)

project_configs=(
    ""
    ""
    ""
    ""
    ""
    ""
    ""
    ""
    ""
    ""
)

# build
for i in "${!project_names[@]}"; do
    project="${project_names[$i]}"
    repo_url="${project_repos[$i]}"
    repo_branch="${project_branches[$i]}"
    repo_config="${project_configs[$i]}"
    echo "Build $project"
    if [ -n "$use_xcode" ]; then
        clone_dir="$projects_dir/xcode/$project"
    else
        clone_dir="$projects_dir/$project"
    fi
    build_project "$repo_url" "$repo_branch" "$clone_dir" "$repo_config" "$PIPELINE_DIR" "$PIPELINE_TYPE"
done