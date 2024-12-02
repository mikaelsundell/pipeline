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
export_var "PATH" "$pipeline_dir/scripts"

# init
if [ -f "$PIPELINE_DIR/settings.ini" ]; then
    source $PIPELINE_DIR/settings.ini
fi

# build type
build_type="${build_type:-release}"
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
alias openpipeline='open $pipeline_dir'
alias openbin='open $pipeline_dir/bin'
alias opendctl='open $pipeline_dir/dctl'
alias opendocumentation='open $pipeline_dir/documentation'
alias openprojects='open $pipeline_dir/projects'
alias openpython='open $pipeline_dir/python'
alias cdpipeline='cd $pipeline_dir'
alias cdbin='cd $pipeline_dir/bin'
alias cddctl='cd $pipeline_dir/dctl'
alias cddocumentation='cd $pipeline_dir/documentation'
alias cdprojects='cd $pipeline_dir/projects'
alias cdpython='cd $pipeline_dir/python'
alias cdtools='cd $pipeline_dir/tools'

alias pipelinetype='echo Pipeline build type: $PIPELINE_TYPE'
alias pipelineupdate='cdpipeline && git pull'

# functions
setbuild() {
    if [[ $1 == "debug" || $1 == "release" ]]; then
        sed -i '' "s/build_type=.*/build_type=$1/" "$PIPELINE_DIR/settings.ini"
        echo "Build type for the pipeline has been changed to '$1'. Please restart your shell session for the changes to take effect."
    else
        echo "Invalid build type specified. Use 'debug' or 'release'."
    fi
}

titlegradient() {
    if [[ -z $1 || -z $2 ]]; then
        echo "Usage: titlegradient <title> <subtitle> <gradient>"
        return 1
    fi
    local title=$1
    local subtitle=$2
    local gradient=$3
    local outputfile="${title// /-}.png"  # Replace spaces with dashes for the filename

    titletool --title "$title" --subtitle "$subtitle" --outputfile "$outputfile" --size "1920,1080" --gradient $gradient && open "./$outputfile"
}
alias setdebug='setbuild debug'
alias setrelease='setbuild release'

# pipeline
echo "Pipeline: initialized with build type: $PIPELINE_TYPE"
