#! /bin/bash
###################

###################

echo -e "    ----- AddROM - fuegt erzeugtes AICP ROM zu lokalem Download Repo hinzu -----\n"
if [ $# -ne 2 ]; then

	echo -e "Usage: addrom.sh <Version> <Device>"
	exit 16
fi
Version=$1
Device=$2
Date=`date +%Y%m%d`
Date2Morrow=$(date +%Y%m%d --date="-1 day")
Date1=`date "+%Y-%m-%d %H:%M:%S"`
BasePath="/home/julian/android/aicp/$Version"
ApacheDestDir="/var/www/html/builds/device/$Device/WEEKLY"
#BasePath=$(pwd)
OutPath=$BasePath/out/target/product/$Device
OutFileNameDel=aicp_$Device"_q-"$Version-WEEKLY-*.zip
OutFileName1=aicp_$Device"_q-"$Version-WEEKLY-$Date2Morrow.zip
OutFileName2=aicp_$Device"_q-"$Version-WEEKLY-$Date.zip

if [ ! -d $OutPath ];then
   echo -e "ERROR\tVerzeichnis: $OutPath existiert nicht"
   exit 16
fi

cd $OutPath
if [ -f $OutFileName1 ];then
	OutFileName=$(ls -1 $OutFileName1)
elif [ -f $OutFileName2 ];then
	OutFileName=$(ls -1 $OutFileName2)
else
	echo -e "ERROR\tKein RomFile gefunden!"
	exit 16
fi
	echo -e "INFO\tRomfile: $OutPath/$OutFileName gefunden"
	echo -e "INFO\tloesche eventuelles altes ROM-file..."
	rm $ApacheDestDir/aicp_*.zip
	echo -e "INFO\tKopiere Romfile nach $ApacheDestDir"
	cp -v $OutPath/$OutFileName $ApacheDestDir

exit 0
