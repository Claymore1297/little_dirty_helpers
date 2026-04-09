#! /bin/bash
# Copyright (C) 2026 Claymore1297 / Julian Veit
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. ./setenv.sh

BASE_PATH="/home/julian/git_Sandbox/edgetx"
SRC_DIR=$BASE_PATH/src
OUT_DIR=$BASE_PATH/out

echo
echo "###########################"
echo "EdgeTX build"
echo "###########################"
echo
echo

case "$1" in
  build)
    echo "Build-Mode:	build"
    build_mode="1"
    ;;
  clean)
    echo "Build-Mode:	clean"
    build_mode="2"
    ;;
  *)
    echo "unknown build-mode: $1"
    echo "Usage: $0 {build|clean|no-clone}"
    exit 1
    ;;
esac

echo

if [ "$#" -lt 4 ]; then
    echo "Usage: $0 {build|clean|no-clone} <Board> <Default-Mode-ID> <Release-Type>"
    echo "Usage: $0 {build|clean|no-clone} TX16S 1 Debug"
  exit 2
fi

BRANCH="main"
GIT_DIR="edgetx_main"

BOARD=$2
MODE=$3
RELEASE_TYPE=$4

echo "Board:		$BOARD"
echo "Default-Mode:	$MODE"
echo "Release-Type:	$RELEASE_TYPE"
echo

DATE=$(date +%Y%m%d)
DEST_FILE="EdgeTX_${BRANCH}_${BOARD}_MODE${MODE}_${RELEASE_TYPE}_${DATE}.bin"


cd $SRC_DIR

if [ "$build_mode" -eq 2 ]; then
    [ -d "$GIT_DIR" ] && rm -rf "$GIT_DIR"
    git clone --recursive -b $BRANCH https://github.com/Claymore1297/edgetx.git $GIT_DIR
fi
cd $BASE_PATH

if [ "$build_mode" -eq 2 ]; then
    rm -rf $OUT_DIR && mkdir $OUT_DIR
fi
cd $OUT_DIR
cmake -LAH $SRC_DIR/$GIT_DIR > ~/edgetx_main-cmake-options.txt
cmake -DPCB=X10 -DPCBREV=$BOARD -DDEFAULT_MODE=$MODE -DGVARS=YES -DLUA_MIXER=YES -DCMAKE_BUILD_TYPE=Debug $SRC_DIR/$GIT_DIR
make configure
make firmware
cd arm-none-eabi
cp firmware.bin $OUT_DIR/$DEST_FILE
echo Firmware created: $OUT_DIR/$DEST_FILE
exit 0

