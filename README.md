Pipeline
====================

[![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg?style=flat-square)](https://github.com/mikaelsundell/icloud-snapshot/blob/master/license.md)

Table of contents
=================

- [Pipeline](#pipeline)
- [Table of contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Code projects](#code-projects)
      - [Building projects](#building-projects)
      - [Building for Xcode (Optional)](#building-for-xcode-optional)
      - [brawtool](#brawtool)
      - [colorpalette](#colorpalette)
      - [colortool](#colortool)
      - [it8tool](#it8tool)
      - [logctool](#logctool)
      - [photographic-dctls](#photographic-dctls)
      - [symmetrytool](#symmetrytool)
      - [texttool](#texttool)
      - [Tensorflow (not built by pipeline)](#tensorflow-not-built-by-pipeline)
  - [Applications](#applications)
      - [Colorman](#colorman)
      - [Colorpicker](#colorpicker)
      - [Jobman](#jobman)
    - [icloud-snapshot](#icloud-snapshot)
  - [Plugins](#plugins)
      - [openimageio.lrplugin](#openimageiolrplugin)
  - [Tools deployment](#tools-deployment)
  - [Documentation](#documentation)
  - [Web Resources](#web-resources)
  
Introduction
---------

The pipeline project is a collection of shell scripts designed to simplify project development and deployment. It includes all the project tools, which can be downloaded separately from the release section—already signed and ready to use on any Mac without requiring a build process. Aimed at developers, it provides access to project source code, scripts, and utilities to streamline the development workflow.

Additionally, the project serves as an experimental test bed for signing and deploying Mac applications.

The 3rdparty project must be built for the pipeline project.

* https://github.com/mikaelsundell/3rdparty

This ensures that the pipeline project efficiently compiles and installs various code projects along with their respective dependencies.

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

To configure your environment for development with debug versions of libraries, use the following command:

```shell
setdebug
```

This sets your environment to use libraries compiled with debugging symbols, facilitating debugging and development.

For configuring your environment to use release versions of libraries, optimized for performance and without debugging symbols, execute:

```shell
setrelease
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

Dependency:

* https://www.blackmagicdesign.com/event/blackmagicrawinstaller

#### colorpalette

Colorpalette is a tool to process and create palettes of unique colors from images.

* https://github.com/mikaelsundell/colorpalette

#### colortool

colortool is a utility set for color space conversions, with support for white point adaptation.

* https://github.com/mikaelsundell/colortool

#### it8tool

it8tool is a set of utilities for computation of color correction matrices from it8 charts.

* https://github.com/mikaelsundell/it8tool

#### logctool

Logctool is a set of utilities for processing logc encoded images.

* https://github.com/mikaelsundell/logctool

#### photographic-dctls

This set of DCTL scripts is all about experimenting with the math behind color science, including ARRI LogC, ACES AP0, Cineon, and more. 

* https://github.com/mikaelsundell/photographic-dctls

#### symmetrytool

Symmetrytool is a utility for exploring the math of symmetry in art and design.

* https://github.com/mikaelsundell/symmetrytool
  
#### texttool

Texttool is a utility for creating text in images

* https://github.com/mikaelsundell/texttool

#### Tensorflow (not built by pipeline)

TensorFlow is an end-to-end open source platform for machine learning. It has a comprehensive, flexible ecosystem of tools, libraries, and community resources that lets researchers push the state-of-the-art in ML and developers easily build and deploy ML-powered applications.

* https://github.com/mikaelsundell/tensorflow


Applications
-------------

Applications for download:

#### Colorman

Colorman is an app for color processing and Inspection with grading, scopes, and scripting capabilities.

* https://github.com/mikaelsundell/colorman/releases

#### Colorpicker

Colorpicker is a versatile Mac application designed to select and capture colors from various screens. It features a color wheel visualizer, aiding users in color design by offering tools to create harmonious color palettes and explore color relationships.

Project page    
https://github.com/mikaelsundell/colorpicker

<a href="https://apps.apple.com/se/app/colorpicker-colors-in-harmony/id6503638316?l=en-GB&mt=12" target="_blank" style="cursor: pointer;">
    <img src="resources/Badge.png" valign="middle" alt="Icon" width="140">
</a>

  
#### Jobman

Jobman is a Mac application designed for efficient batch processing of files based on predefined tasks.

Project page    
https://github.com/mikaelsundell/jobman/releases

<a href="https://apps.apple.com/se/app/jobman-batch-processing/id6738392819?l=en-GB&mt=12" target="_blank" style="cursor: pointer;">
    <img src="resources/Badge.png" valign="middle" alt="Icon" width="140">
</a>

### icloud-snapshot

icloud-snapshot is a utility to copy an icloud directory to a snapshot directory for archival purposes. The utility will download and release local items when needed to save disk space.

* https://github.com/mikaelsundell/icloud-snapshot


Plugins
-------

#### openimageio.lrplugin

openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports using openimageio image processing tools

* https://github.com/mikaelsundell/openimageio-lrplugin


Tools deployment
-------

Deploy stand-Alone tools for release

```shell
cdprojects
./build_projects release
```

Build tools with signing and notarization

```shell
cdtools
./build_tools release --sign
```

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
