Readme for Pipeline
====================

[![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg?style=flat-square)](https://github.com/mikaelsundell/icloud-snapshot/blob/master/license.md)

Table of Contents
=================

- [Readme for Pipeline](#readme-for-pipeline)
- [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Code projects](#code-projects)
      - [Building projects](#building-projects)
      - [Building for Xcode (Optional)](#building-for-xcode-optional)
      - [brawtool](#brawtool)
      - [colorpalette](#colorpalette)
      - [dctl](#dctl)
      - [it8tool](#it8tool)
      - [logctool](#logctool)
      - [overlaytool](#overlaytool)
      - [Tensorflow (not built by pipeline)](#tensorflow-not-built-by-pipeline)
  - [Applications](#applications)
      - [Automator](#automator)
      - [Colorman](#colorman)
      - [Colorpicker](#colorpicker)
    - [icloud-snapshot](#icloud-snapshot)
  - [Plugins](#plugins)
      - [openimageio.lrplugin](#openimageiolrplugin)
  - [Documentation](#documentation)
  - [Web Resources](#web-resources)
  
Introduction
---------

The 3rdparty project must be built parallel to the pipeline project.

* https://github.com/mikaelsundell/3rdparty

This configuration ensures that the pipeline project efficiently compiles and installs various code projects along with their respective dependencies.

To initialize the pipeline, execute the following command in your terminal:

```shell
source ./pipeline.sh
```

Furthermore, to incorporate Pipeline into your .zshrc for automatic setup, append the following script:

```shell
export PIPELINE_DIR="<pipeline>"
if [[ -f "$PIPELINE_DIR/pipeline.sh" ]]; then
    source "$PIPELINE_DIR/pipeline.sh"
else
    echo "pipeline.sh not found in $PIPELINE_DIR, skipping..."
fi
```

For debug builds use:

```shell
source "$PIPELINE_DIR/pipeline.sh debug"
```

Code projects
-------------

#### Building projects

To build the projects within the pipeline, navigate to the projects directory inside your pipeline folder and execute the build script:

```shell
cdprojects
./build.sh
```
#### Building for Xcode (Optional)

If you are developing with Xcode and would like to configure the build for Xcode, you can add the --xcode option to the build command. This will enable specific configurations suitable for Xcode development:

```shell
cdprojects
./build.sh --xcode
```

This option ensures that the projects are built using the Xcode generator with directory prefix -xcode, making them compatible with Xcode development environments. Projects built with Xcode will not install due to signing issues, Xcode is only intended for development only.

#### brawtool

Brawtool is a set of utilities for processing braw encoded images.

* https://github.com/mikaelsundell/brawtool

#### colorpalette

Colorpalette is a tool to process and create palettes of unique colors from images.

* https://github.com/mikaelsundell/colorpalette

#### dctl

DCTL is a set of dctl scripts for use with davinci resolve.

* https://github.com/mikaelsundell/colorpalette

#### it8tool

Simple utility to demonstrate the capabilities of Qt painter for vectorscope yuv, yiq and rgb color models.

* https://github.com/mikaelsundell/it8tool

#### logctool

Logctool is a set of utilities for processing logc encoded images.

* https://github.com/mikaelsundell/logctool

#### overlaytool

Overlaytool is a utility for creating overlay images.

* https://github.com/mikaelsundell/overlaytool

#### Tensorflow (not built by pipeline)

TensorFlow is an end-to-end open source platform for machine learning. It has a comprehensive, flexible ecosystem of tools, libraries, and community resources that lets researchers push the state-of-the-art in ML and developers easily build and deploy ML-powered applications.

* https://github.com/mikaelsundell/tensorflow


Applications
-------------

Applications for download:

#### Automator

Automator is a set of utilities for batch processing files

* https://github.com/mikaelsundell/automator/releases

#### Colorman

Colorman is an app for color processing and Inspection with grading, scopes, and scripting capabilities.

* https://github.com/mikaelsundell/colorman/releases

#### Colorpicker

Colorpicker is a versatile Mac application designed to select and capture colors from various screens. It features a color wheel visualizer, aiding users in color design by offering tools to create harmonious color palettes and explore color relationships.

* https://github.com/mikaelsundell/colorpicker/releases

### icloud-snapshot

icloud-snapshot is a utility to copy an icloud directory to a snapshot directory for archival purposes. The utility will download and release local items when needed to save disk space.

* https://github.com/mikaelsundell/icloud-snapshot


Plugins
-------

#### openimageio.lrplugin

openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports using openimageio image processing tools

* https://github.com/mikaelsundell/openimageio-lrplugin


Documentation
-------------

Aces
* https://github.com/mikaelsundell/pipeline/tree/master/documentation/aces

Arri
* https://github.com/mikaelsundell/pipeline/tree/master/documentation/arri

Blackmagick
* https://github.com/mikaelsundell/pipeline/tree/master/documentation/blackmagic

Kodak
* https://github.com/mikaelsundell/pipeline/tree/master/documentation/kodak


Web Resources
-------------

* GitHub page:        https://github.com/mikaelsundell/pipeline
* Issues              https://github.com/mikaelsundell/pipeline/issues
