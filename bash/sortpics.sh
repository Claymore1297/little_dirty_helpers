#! /bin/bash
# Copyright (C) 2024 Claymore1297 / Julian Veit
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
  Usage: $(basename $0) <source folder> <destination folder>
EOM
  exit 1
}

[ $# -ne 2 ] && usage

SourceDir=$1
DestDir=$2

# rename files with blanks first
for f in $SourceDir/*\ *; do mv "$f" "${f// /_}"; done
getallFiles=$(ls $SourceDir/*)

for i in $getallFiles;do

    echo "INFO: actual file: $i"
	getYear=$(exiftool  $i | grep "Create Date" | head -1 | cut -d : -f2 | tr -d ' ')
    getMonth=$(exiftool  $i | grep "Create Date" | head -1 | cut -d : -f3 | tr -d ' ')
	checkYear=$(echo $getYear | wc -c)

	getYear1=$(exiftool  $i | grep "Date/Time Original" | head -1 | cut -d : -f2 | tr -d ' ')
    getMonth1=$(exiftool  $i | grep "Date/Time Original" | head -1 | cut -d : -f3 | tr -d ' ')
	checkYear1=$(echo $getYear1 | wc -c)

	if [ $checkYear == 5 ];then
        echo "INFO: exif content of: $i valid"
        TargetDir=$DestDir/${getYear}/${getYear}_${getMonth}
	elif [ $checkYear1 == 5 ];then
	    echo "INFO: exif content of: $i valid (apple)"
        TargetDir=$DestDir/${getYear1}/${getYear1}_${getMonth1}
    else
	    echo "ERROR: exif content of: $i invalid"
		TargetDir="${DestDir}/unsorted"
    fi

	if [ ! -d $TargetDir ];then
	    mkdir -p $TargetDir
		echo "INFO: creating folder: $TargetDir"
	fi
	echo "INFO: move image: $i to $TargetDir"
	mv -if $i $TargetDir

    echo -e
done

exit
