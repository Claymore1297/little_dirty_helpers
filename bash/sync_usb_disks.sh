#!/bin/bash

#############################
function do_sync ()
{
    Source="/run/media/julian/Seagate Basic"
    Dest="/run/media/julian/DuneHDD"
    #Source="/run/media/julian/DuneHDD"
    #Dest="/run/media/julian/Seagate Basic"
    echo "syncing folder: $1 ($Source to $Dest)"
    echo "rsync -av --ignore-existing --progress --delete \"$Source/$1\" \"$Dest\""
    rsync -av --ignore-existing --progress --delete "$Source/$1" "$Dest"
}
#############################

#############################
function usage ()
{
    echo "Usage: $0 <Serien|Filme|All>"
    exit 1
}
#############################

if [ $# -ne 1 ];then
    usage
fi

case $1 in
  Serien)
    do_sync "$1"
    ;;
  Filme)
    do_sync "$1"
    ;;
  All)
    do_sync Serien
    do_sync Filme
    ;;
  *)
    usage
    ;;
esac
exit 0
