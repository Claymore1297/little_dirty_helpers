#! /bin/bash
#
# Copyright (C) 2018 AICP
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

#
if [ ! $ANDROID_BUILD_TOP ];then
	echo "please run build/envsetup.sh first"
	exit 1
fi

cd $ANDROID_BUILD_TOP
. build/envsetup.sh
getPatchFiles=$(find $ANDROID_BUILD_TOP/device -name patches.txt)

for i in $getPatchFiles;do
    echo -e "found patches.txt-file: $i\n"
    while read line
    do
       if [[ ${line:0:1} != "#" ]]; then
           commitId=$(echo $line | cut -d " " -f 1)
           commitUrl=$(echo $line | cut -d " " -f 2)
           commitRepo=$(echo $line | cut -d " " -f 3)
# start picking
           repopick $commitId -g $commitUrl -P $commitRepo
       fi
    done <$i
done
exit 0
