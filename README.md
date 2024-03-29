Readme for Pipeline
====================

[![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg?style=flat-square)](https://github.com/mikaelsundell/icloud-snapshot/blob/master/license.md)

Table of Contents
=================

- [Readme for Pipeline](#readme-for-pipeline)
- [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Code projects](#code-projects)
      - [brawtool](#brawtool)
      - [colorpalette](#colorpalette)
      - [dctl](#dctl)
      - [it8tool](#it8tool)
      - [logctool](#logctool)
      - [overlaytool](#overlaytool)
      - [Tensorflow](#tensorflow)
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

The pipeline project will build and install code projects and their dependencies.

```shell
source ./pipeline.sh
```

Pipeline can also be added to .zshrc:

```shell
export PIPELINE_DIR="<pipeline>"
if [[ -f "$PIPELINE_DIR/pipeline.sh" ]]; then
    source "$PIPELINE_DIR/pipeline.sh"
else
    echo "pipeline.sh not found in $PIPELINE_DIR, skipping..."
fi
```

Code projects
-------------

Pipeline build 

#### brawtool

Logctool a set of utilities for processing braw encoded images.

* https://github.com/mikaelsundell/logctool

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

Logctool a set of utilities for processing logc encoded images.

* https://github.com/mikaelsundell/logctool

#### overlaytool

Overlaytool is a utility for creating overlay images.

* https://github.com/mikaelsundell/overlaytool

#### Tensorflow

TensorFlow is an end-to-end open source platform for machine learning. It has a comprehensive, flexible ecosystem of tools, libraries, and community resources that lets researchers push the state-of-the-art in ML and developers easily build and deploy ML-powered applications.

* https://github.com/mikaelsundell/tensorflow


Applications
-------------

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
* Documentation: https://github.com/mikaelsundell/pipeline/tree/master/documentation/aces

Arri
* Documentation: https://github.com/mikaelsundell/pipeline/tree/master/documentation/arri

Blackmagick
* Documentation: https://github.com/mikaelsundell/pipeline/tree/master/documentation/blackmagic

kodak
* Documentation: https://github.com/mikaelsundell/pipeline/tree/master/documentation/kodak


Web Resources
-------------

* GitHub page:        https://github.com/mikaelsundell/pipeline
* Issues              https://github.com/mikaelsundell/pipeline/issues
