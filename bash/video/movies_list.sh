#! /bin/bash

cd "$1"
find -name "*.mkv" -o -name "*.avi" -o -name "*.mp4" -type f | sort > movies.txt

gendre_save="NN"
echo -e "\n#------------------------#"
echo -e "# --> Julian's Filme <-- #"
echo -e "#------------------------#"
while IFS= read -r line; do

    newline=$(echo "${line/.\//}")
    gendre=$(echo $newline | cut -d "/" -f1)
    movie=$(echo $newline | cut -d "/" -f2)

    if [ "$gendre_save" != "$gendre" ];then
        gendre_save=$gendre
        echo -e "\n$gendre"
        echo -e "-------------"
    fi

    echo -e "\t - $movie"
done < movies.txt

echo -e "\n#--------E-N-D-------------#"

rm -f movies.txt

exit 0
