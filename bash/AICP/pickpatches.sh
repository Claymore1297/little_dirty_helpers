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

# relative path to envsetup.sh in android build environment
ENVSETUP_SCRIPT="build/envsetup.sh"

# check for the basedir of the build env
if  [ $# == 1 ] && [ -d $1 ];then
   ANDROID_BUILD_TOP=$1
fi
if [ ! $ANDROID_BUILD_TOP ];then
	echo -e "\nERROR: please run . $ENVSETUP_SCRIPT first or define root of your build-environment as first argument of this script"
	echo "Usage: $0 <path to android build env>"
	exit 1
fi

cd $ANDROID_BUILD_TOP
# if envsetup.sh exists, run it or abort
if [ -f $ENVSETUP_SCRIPT ];then
    . $ENVSETUP_SCRIPT
else
   echo "ERROR: script $ENVSETUP_SCRIPT not exist!"
   exit 1
fi

# search for patches.txt in device-dir
getPatchFiles=$(find $ANDROID_BUILD_TOP/device -name patches.txt)
# parse found files
for i in $getPatchFiles;do
    echo -e "found patches.txt-file: $i\n"
    while read line
    do
       if [[ ${line:0:1} != "#" ]]; then
           commitId=$(echo $line | cut -d " " -f 1)
           commitUrl=$(echo $line | cut -d " " -f 2)
           commitRepo=$(echo $line | cut -d " " -f 3)
	   if [ $commitId ] && [ $commitUrl ] && [ $commitRepo ];then
               # start picking
               repopick $commitId -g $commitUrl -P $commitRepo
           fi
       fi
    done <$i
done
exit 0
