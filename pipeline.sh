#!/bin/bash
##  Copyright 2022-present Contributors to the 3rdparty project.
##  SPDX-License-Identifier: BSD-3-Clause
##  https://github.com/mikaelsundell/pipeline

# export var
export_var() {
    local var_name="$1"
    local var_path="$2"
    eval "value=\$$var_name"
    if [ -z "$value" ]; then
        eval "export $var_name=\"$var_path\""
    else
        eval "export $var_name=\"\$$var_name:$var_path\""
    fi
}

if [ -n "$PIPELINE_DIR" ]; then
    pipeline_dir="$PIPELINE_DIR"
else
    echo "could not find PIPELINE_DIR, make sure it's defined"
    exit 1
fi
export_var "PATH" "$pipeline_dir/bin"

# build type
build_type="${1:-debug}"
if [ "$build_type" != "debug" ] && [ "$build_type" != "release" ]; then
    echo "invalid build type: $build_type (use 'debug' or 'release')"
    exit 1
fi
export_var "PIPELINE_TYPE" $build_type

# 3rdparty
machine_arch=$(uname -m)
thirdparty_dir="$pipeline_dir/../3rdparty/build/macosx/$machine_arch.$build_type"
thirdparty_dir=$(python3 -c "import os; print(os.path.realpath('$thirdparty_dir'))")
export_var "THIRDPARTY_DIR" $thirdparty_dir

# bin
bin_dir="$thirdparty_dir/bin"
if [ -d "$bin_dir" ]; then
    export_var "PATH" $bin_dir
else
    echo "3rdparty bin could not be found in: $bin_dir, make sure it's installed"
fi

# check if cmake is in the path
if ! command -v cmake &> /dev/null; then
    export_var "PATH" "/Applications/CMake.app/Contents/bin"
    if ! command -v cmake &> /dev/null; then
        echo "cmake could not be found, make sure it's installed"
        exit 1
    fi
fi

# site-packages
sitepackages_dir="$thirdparty_dir/site-packages"
if [ -d "$sitepackages_dir" ]; then
    export_var "PYTHONPATH" $sitepackages_dir
else
    echo "3rdparty site-packages could not be found in: $sitepackages_dir, make sure it's installed"
fi

# alias
alias openpipeline='cd $pipeline_dir'
alias opendocumentation='cd $pipeline_dir/documentation'
alias openprojects='cd $pipeline_dir/projects'
alias openpython='cd $pipeline_dir/python'

# pipeline
echo "Pipeline: initialized"
