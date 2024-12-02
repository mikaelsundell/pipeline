#!/bin/bash
##  Copyright 2022-present Contributors to the 3rdparty project.
##  SPDX-License-Identifier: BSD-3-Clause
##  https://github.com/mikaelsundell/pipeline

usage()
{
cat << EOF
macdeploy.sh -- Deploy mac executable to path including dependencies 

usage: $0 [options]

Options:
   -h, --help              Print help message
   -v, --verbose           Print verbose
   -e, --executable        Path to executable
   -d, --dependencies      Paths to dependencies (comma-separated)
   -p, --path              Path to deploy
   -o, --overwrite         Overwrite files
   -i, --identity          Developer ID identity for signing
EOF
}

# Parse arguments
i=0; argv=()
for ARG in "$@"; do
    argv[$i]="${ARG}"
    i=$((i + 1))
done

i=0; findex=0
while test $i -lt $# ; do
    ARG="${argv[$i]}"
    case "${ARG}" in
        -h|--help) 
            usage;
            exit;;
        -v|--verbose)
            verbose=1;;
        -e|--executable) 
            i=$((i + 1)); 
            executable="${argv[$i]}";;
        -d|--dependencies) 
            i=$((i + 1)); 
            dependencies="${argv[$i]}";;
        -p|--path) 
            i=$((i + 1)); 
            path="${argv[$i]}";;
        -o|--overwrite)
            overwrite=1;;
        -i|--identity)
            i=$((i + 1)); 
            developerid_identity="${argv[$i]}";;
        *) 
            if ! test -e "${ARG}" ; then
                echo "Unknown argument or file '${ARG}'"
            fi;;
    esac
    i=$((i + 1))
done

if [ -z "${executable}" ] || [ -z "${path}" ]; then
    usage
    exit 1
fi

IFS=',' read -r -a dependency_list <<< "$dependencies"

function sign_binary() {
    local file_path="${1}"
    if [ -n "$developerid_identity" ]; then
        echo "Signing binary: $file_path"
        codesign --force --deep --sign "$developerid_identity" --timestamp --options runtime "$file_path"
    else
        echo "No Developer ID identity provided. Skipping signing for: $file_path"
    fi
}

function copy_deploy() {
    local copy_path="${1}"
    local deploy_path="${2}"

    if [ $overwrite ]; then
        echo "Copy and overwrite file '${copy_path}' to '${deploy_path}'"
        cp -f "${copy_path}" "${deploy_path}"
    else
        if ! [ -f "$deploy_path" ]; then
            echo "Copy file '${copy_path}' to '${deploy_path}'"
            cp "${copy_path}" "${deploy_path}"

            if [[ `file "${deploy_path}" | grep 'shared library'` ]]; then
                local deploy_base=$(basename "${deploy_path}")
                local deploy_id="@executable_path/${deploy_base}"

                echo "Change install name id to '${deploy_id}' for '${deploy_path}'"
                install_name_tool -id "${deploy_id}" "${deploy_path}"
            fi
        else
            echo "Skip copy file '${copy_path}' to '${deploy_path}', already exists"
        fi            
    fi
    copy_dependency "${deploy_path}"
    sign_binary "${deploy_path}"
}

function copy_dependency() {
    local copy_path="${1}"
    local copy_dir=$(dirname "${copy_path}")

    local dependency_paths=$(otool -L "${copy_path}" | tail -n+2 | awk '{print $1}')
    local dependency_path
    for dependency_path in ${dependency_paths[@]}; do
        for dep_dir in "${dependency_list[@]}"; do
            if [[ "${dependency_path}" == "${dep_dir}"* ]]; then
                if [ "${copy_path}" != "${dependency_path}" ]; then
                    local dependency_base=$(basename "${dependency_path}")
                    local deploy_path="${copy_dir}/${dependency_base}"

                    echo "Copy dependency '${dependency_path}' to '${deploy_path}'"
                    copy_deploy "${dependency_path}" "${deploy_path}"

                    local deploy_base=$(basename "${deploy_path}")
                    local deploy_id="@executable_path/${deploy_base}"
                    echo "Change install dependency id to '${deploy_id}' from '${dependency_path}' for '${copy_path}'"
                    install_name_tool -change "${dependency_path}" "${deploy_id}" "${copy_path}"
                fi
            fi
        done
    done
}

function main {
    if [[ $(file "${executable}") =~ executable ]]; then
        echo "Start to deploy executable: ${executable}"
        local copy_path="${executable}"
        local copy_name=$(basename "${executable}")
        local deploy_path="${path}/${copy_name}"
        copy_deploy "${copy_path}" "${deploy_path}"
    else
        echo "File is not an executable '${executable}'"
    fi
}

main
