#!/bin/bash

#############################
function do_sync ()
{
    #Dest="/run/media/julian/DuneHDD"
    #Source="/run/media/julian/Seagate Basic"
	Source="/run/media/julian/DuneHDD"
    Dest="/run/media/julian/Seagate Basic"
    echo "syncing folder: $1 ($Source to $Dest)"
    echo "rsync -av --ignore-existing --progress --delete \"$Source/$1\" \"$Dest\""
    rsync -av --ignore-existing --progress --delete "$Source/$1" "$Dest"
}
#############################

case $1 in
  Serien)
    do_sync $1
    ;;
  Filme)
    do_sync $1
    ;;
  All)
    do_sync Serien
    do_sync Filme
    ;;
    *)
    echo -n "Error: unknown parameter: $1"
    exit 1
    ;;
esac
exit 1
