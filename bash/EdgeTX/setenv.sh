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

BASE_PATH="/home/julian/git_Sandbox/edgetx"
SRC_DIR=$BASE_PATH/src
OUT_DIR=$BASE_PATH/out
TOOLSCHAIN_BASE="/home/julian/git_Sandbox/edgetx/tools"
[ ! -d "$TOOLSCHAIN_BASE" ] && mkdir "$TOOLSCHAIN_BASE"

# version definition
TOOLCHAIN_VERSION="14.2.rel1"

# ===== PATHS =====
TOOLCHAIN_DIR="$TOOLSCHAIN_BASE/arm-gnu-toolchain-$TOOLCHAIN_VERSION-x86_64-arm-none-eabi"
TOOLCHAIN_BIN="$TOOLCHAIN_DIR/bin"

# ===== INSTALL TOOLCHAIN =====
if [ ! -d "$TOOLCHAIN_DIR" ]; then
    echo ">>> Downloading ARM toolchain... (${TOOLSCHAIN_VERSION})"
    cd "$TOOLSCHAIN_BASE"
    wget https://developer.arm.com/-/media/Files/downloads/gnu/$TOOLCHAIN_VERSION/binrel/arm-gnu-toolchain-$TOOLCHAIN_VERSION-x86_64-arm-none-eabi.tar.xz
    tar -xf arm-gnu-toolchain-$TOOLCHAIN_VERSION-*.tar.xz
fi

export PATH=$TOOLCHAIN_BIN:$PATH

