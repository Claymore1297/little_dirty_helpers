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

# define some variables
TempFile="/tmp/findCommit.tmp"
Green='\033[0;32m'
HeadLine='\e[0;30;42m'
Red='\033[0;31m'
Yellow='\033[0;33m'
NC='\033[0m' # No Color

# some header output
echo ""
echo -e "$HeadLine-------------find git Commit ----------------$NC"
echo ""
# Usage
if [ $# -ne 2 ]; then
	echo -e "Usage:$Yellow findCommit.sh <File> <catchword>$NC"
	echo ""
	exit 16
fi

echo -e "search for: $Green$2$NC in file: $Green$1$NC"
echo ""
# save commit-list in temp file
git log --oneline -- $1 > $TempFile

#####
for i in $(cat $TempFile | cut -d " " -f1);do
	getOutput=$(git show $i | grep $2)
# if a hit was found
	if [ $(git show $i | grep $2| wc -l) -ge 1 ];then
		getHeader=$(git log $i --oneline --no-walk)
		echo -e "$Red$getHeader$NC"
		git show $i | grep --color $2
		echo -e "$Yellow##############################################$NC"
		echo ""
	fi
done
#####

# cleanup
rm -f $TempFile
exit 0

