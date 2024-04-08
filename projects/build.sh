#!/bin/bash
##  Copyright 2022-present Contributors to the 3rdparty project.
##  SPDX-License-Identifier: BSD-3-Clause
##  https://github.com/mikaelsundell/pipeline

# Initialize Xcode flag as empty
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
    local project_dir="$2"
    local install_dir="$3"
    local build_type="$4"

    if [ -n "$use_xcode" ]; then
        project_dir="$project_dir-xcode"
    fi

    if [ -d "$project_dir" ]; then
        echo "Project dir $project_dir already exists, will be skipped"
        return 1
    fi

    echo "Cloning $project_dir from repository"
    git clone "$repo_url" "$project_dir"
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
        -DCMAKE_PREFIX_PATH=$THIRDPARTY_DIR \
        $cmake_module_path $cmake_xcode

    if [ $? -ne 0 ]; then
        echo "CMake configuration failed"
        return 1
    fi

    echo "Building and installing project"
    if [ -n "$use_xcode" ]; then
        cmake --build $build_dir --config $build_type
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

# brawtool
echo "Build brawtool"
repo_url="https://github.com/mikaelsundell/brawtool.git"
clone_dir="$projects_dir/brawtool"
build_project $repo_url $clone_dir $PIPELINE_DIR $PIPELINE_TYPE

# colorpalette
echo "Build colorpalette"
repo_url="https://github.com/mikaelsundell/colorpalette"
clone_dir="$projects_dir/colorpalette"
build_project $repo_url $clone_dir $PIPELINE_DIR $PIPELINE_TYPE

# dctl
echo "Build dctl"
repo_url="https://github.com/mikaelsundell/dctl"
clone_dir="$projects_dir/dctl"
build_project $repo_url $clone_dir $PIPELINE_DIR $PIPELINE_TYPE

# it8tool
echo "Build it8tool"
repo_url="https://github.com/mikaelsundell/it8tool.git"
clone_dir="$projects_dir/it8tool"
build_project $repo_url $clone_dir $PIPELINE_DIR $PIPELINE_TYPE

# logctool
echo "Build logctool"
repo_url="https://github.com/mikaelsundell/logctool.git"
clone_dir="$projects_dir/logctool"
build_project $repo_url $clone_dir $PIPELINE_DIR $PIPELINE_TYPE

# overlaytool
echo "Build overlaytool"
repo_url="https://github.com/mikaelsundell/overlaytool.git"
clone_dir="$projects_dir/overlaytool"
build_project $repo_url $clone_dir $PIPELINE_DIR $PIPELINE_TYPE

# titletool
echo "Build titletool"
repo_url="https://github.com/mikaelsundell/titletool.git"
clone_dir="$projects_dir/titletool"
build_project $repo_url $clone_dir $PIPELINE_DIR $PIPELINE_TYPE
