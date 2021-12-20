#! /bin/bash
#
# Copyright (C) 2019 Claymore1297 / Julian Veit
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

usage() {
  cat <<EOM
  Usage: $(basename $0) <OS> <VERSION> <DEVICE> <ROM-Zip>
EOM
  exit 1
}

[ $# -ne 4 ] && usage

OS="$1"
VERSION="$2"
DEVICE="$3"
FILETOUPLOAD="$4"

if [ ! -f $HOME/.uploadROMrc ];then
    echo "ERROR: needed RC-File .uploadROMrc does not exist!"
    exit 1
fi
# include rc-file
. $HOME/.uploadROMrc

LPATH="$ANDROID_BASE_PATH/out/target/product/$DEVICE"
RPATH="$OS/$VERSION/$DEVICE"

if [ ! -d "$LPATH" ];then
    echo "ERROR: local path: $LPATH does not exist!"
    exit 1
fi

if [ ! -f $LPATH/$FILETOUPLOAD ];then
    echo "ERROR: ROM-file: $LPATH/$FILETOUPLOAD does not exist!"
    exit 1
fi

ftp -inv $HOST <<EOF
user $USER $PASSWORD
cd $RPATH
pwd
lcd $LPATH
put $FILETOUPLOAD.sha256sum
put $FILETOUPLOAD
bye
EOF

exit 0
