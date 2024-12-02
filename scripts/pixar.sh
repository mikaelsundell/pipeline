#!/bin/bash
# source pixar.sh

# default location for pixar
PIXAR_DIR="/Applications/Pixar"

# find the latest prman pro server version
RMANTREE=$(ls -d $PIXAR_DIR/RenderManProServer-* | sort -V | tail -n 1)

# check if prman installation exists
if [ -d "$RMANTREE" ]; then
  echo "Found RenderMan installation: $RMANTREE"
  export PIXAR_LICENSE_FILE="$PIXAR_DIR/pixar.license"
  export RMANTREE="$RMANTREE"
  export PATH="$RMANTREE/bin:$PATH"
  echo "PIXAR_LICENSE_FILE set to $PIXAR_LICENSE_FILE"
  echo "RMANTREE set to $RMANTREE"
  echo "PATH updated with $RMANTREE/bin"

else
  echo "RenderMan installation not found in $PIXAR_DIR"
  exit 1
fi
