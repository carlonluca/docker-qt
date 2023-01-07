#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

"$SCRIPT_DIR/build_qt6_amd64_git.sh" "$1"
"$SCRIPT_DIR/build_qt6_arm64_git.sh" "$1"
"$SCRIPT_DIR/build_qt6_and_git.sh" "$1"
