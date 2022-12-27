#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

"$SCRIPT_DIR/build_qt6_amd64.sh" "$1"
"$SCRIPT_DIR/build_qt6_arm64.sh" "$1"
"$SCRIPT_DIR/build_qt6_and.sh" "$1"
