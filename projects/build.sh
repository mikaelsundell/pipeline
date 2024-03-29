#!/bin/bash
##  Copyright 2022-present Contributors to the 3rdparty project.
##  SPDX-License-Identifier: BSD-3-Clause
##  https://github.com/mikaelsundell/pipeline

# export var
build_project() {
    local repo_url="$1"
    local project_dir="$2"
    local install_dir="$3"
    local build_dir="${project_dir}/build"
    local build_type="$4"

    if [ -d "$project_dir" ]; then
        echo "Project dir $project_dir already exists, please remove before running this script"
        return 1
    fi

    # Step 1: Clone the repo
    echo "Cloning $project_dir from GitHub..."
    git clone "$repo_url" "$project_dir"
    if [ $? -ne 0 ]; then
        echo "Failed to clone repository."
        return 1
    fi

    # Step 2: Create a build directory and navigate to it
    echo "Creating build directory..."
    mkdir -p "$build_dir"
    cd "$build_dir" || return

    echo "Configuring project with CMake..."
    cmake .. -DCMAKE_BUILD_TYPE=$build_type -DCMAKE_INSTALL_PREFIX=$install_dir
    if [ $? -ne 0 ]; then
        echo "CMake configuration failed."
        return 1
    fi

    # Step 4: Build the project
    echo "Building project..."
    cmake --build $build_dir #--target install
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

# projects
projects_dir="$PIPELINE_DIR/projects"
install_dir="$PIPELINE_DIR"

# brawtool
echo "Build brawtool"


# colorpalette


# it8tool


# logctool
echo "Build logctool"
repo_url="https://github.com/mikaelsundell/logctool.git"
clone_dir="$projects_dir/logctool"

build_project $repo_url $clone_dir $PIPELINE_DIR $PIPELINE_TYPE

# overlaytool






