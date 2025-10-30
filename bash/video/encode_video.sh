#! /bin/bash

orginaldir="orginal-files"
identifier="_crf20_av1"
cd "$1"

[ ! -d $orginaldir ] && mkdir $orginaldir
for i in *.mkv;
do
    echo "found file for encoding: $i"
    if [[ "$i" =~ "$identifier" ]];then
        echo "ignoring file, seems already encoded!"
    else
        filebase=$(echo "$i" |  awk -F".mkv" '{print $1}')
        #echo "ffmpeg -i \"$i\" -map 0 -c:v libsvtav1 -crf 20 -preset 4 -c:a copy -c:s copy \"${filebase}${identifier}.mkv\""
        ffmpeg -i "$i" -map 0 -c:v libsvtav1 -crf 20 -preset 4 -c:a copy -c:s copy "${filebase}${identifier}.mkv"
        mv "$i" $orginaldir
    fi
done

