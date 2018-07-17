#! /bin/bash

echo -e "    ----- Make AICP 13.1 Build -----\n"
if [ $# -eq 0 ]; then

	echo -e "Usage: mkaicpbuild.sh <Device> <BO|NoSync|OnlySync> <NoSwitch>(optional)"
	exit 16
fi

Device=$1
Mode=$2
Runlevel=$3
BasePath="/home/julian/android/aicp-13.1"

export LOS_RUNLEVEL_SWITCH=1
if [ $Runlevel ] && [ $Runlevel == "NoSwitch" ];then
export LOS_RUNLEVEL_SWITCH=0
fi

#if [ $LOS_RUNLEVEL_SWITCH == 1 ];then
#echo -e "INFO\twechsle in Runlevel 3"
#sudo init 3
#fi

if [ $Mode ] && [ $Mode == "BO" ];then
	echo -e "INFO\tBuild only - NO SYNC + NO ADDROM"
	export LOS_GIT_SYNC=0
	export LOS_OUT_WIPE=0
	export LOS_ADDROM=1
	export LOS_BUILD=1
elif [ $Mode ] && [ $Mode == "NoSync" ];then

        echo -e "INFO\tBuild only - NO SYNC"
        export LOS_GIT_SYNC=0
        export LOS_OUT_WIPE=1
        export LOS_ADDROM=1
	export LOS_BUILD=1
elif [ $Mode ] && [ $Mode == "OnlySync" ];then
        export LOS_GIT_SYNC=1
        export LOS_OUT_WIPE=1
        export LOS_ADDROM=0
	export LOS_BUILD=0

else
	export LOS_GIT_SYNC=1
	export LOS_OUT_WIPE=1
	export LOS_ADDROM=1
	export LOS_BUILD=1
fi

if [ ! -d $BasePath ];then
	echo -e "ERROR\tBase Path: $BasePath existiert nicht!"
	exit 16
fi


cd $BasePath
if [ "$LOS_OUT_WIPE" == "1" ];then
	echo -e "INFO\tloesche altes out-Verzeichnis: $BasePath/out"
	. build/envsetup.sh

	mka clobber
	rm -rf $BasePath/out
else
	echo -e "INFO\tOut-Dir wird nicht geputzt"
fi

$BasePath/prebuilts/misc/linux-x86/ccache/ccache -c
$BasePath/prebuilts/sdk/tools/jack-admin list-server && $BasePath/prebuilts/sdk/tools/jack-admin kill-server
$BasePath/prebuilts/misc/linux-x86/ccache/ccache -M 50G
. build/envsetup.sh
if [ "$LOS_GIT_SYNC" == "1" ];then

	DirsToCleanup="packages/apps/AICP_OTA vendor/htc/hima-common kernel/htc/msm8994 system/media hardware/qcom/audio-caf/msm8994 frameworks/av device/htc/hima-common device/htc/himaul device/htc/himawl"
	for i in $DirsToCleanup;do
		echo "Cleanup Dir: $i"
		cd $i
		git reset --hard m/o8.1
		git clean -dfx
		cd $BasePath
		repo sync -f --force-sync -q $i 
	done

	repo sync -q -f --force-sync
else
	echo -e "INFO\tkein REPO-SYNC ausgeführt"
fi

if [ "$LOS_GIT_SYNC" == "1" ];then

~/git_Sandbox/Claymore1297/little_dirty_helpers/bash/AICP/pickpatches.sh
repopick 69407 69404 

# kernel
#repopick 70418

repopick 70727
#repopick 210018-210024

#cd $BasePath
#cd  device/htc/hima-common
#git fetch ~/git_Sandbox/Claymore1297/android_device_htc_hima-common 
#git cherry-pick 06686daf 
#git cherry-pick 5fab080a
#git cherry-pick e5e19ebd

#cd $BasePath
#cd kernel/htc/msm8994
#git fetch ~/git_Sandbox/Claymore1297/android_kernel_htc_msm8994
#git cherry-pick -m 1 6484cfb5fc7f 
#git cherry-pick -m 1 293fe0ca5102
#git cherry-pick -m 1 c093600fb9fd
#git cherry-pick -m 1 2b2fa657cd64
#git cherry-pick -m 1 e3f385c719ff
#git cherry-pick -m 1 62278abfc51d
#git cherry-pick 00cd10fc2e5a
#git cherry-pick -m 1 b18b2bd96b6e
#git cherry-pick -m 1 37766b1d4c6b
#git cherry-pick -m 1 051301962008
#git cherry-pick -m 1 441208b3cb81
#git cherry-pick -m 1 25c2b6dbfaab
#git cherry-pick -m 1 69fd8140c158 
#git cherry-pick 74b909999774 
#git cherry-pick -m 1 08530a072cc8 
#git cherry-pick -m 1 91dc1f536926
#git cherry-pick -m 1 6a3662a5b3f9
#git cherry-pick -m 1 2ea6f183b243
#git cherry-pick -m 1 1abfa82e7af1
#git cherry-pick -m 1 7a8c7bdf1e2b
#git cherry-pick -m 1 9fa603eafb9e
#git cherry-pick fd30c4af754a
#git cherry-pick -m 1 72560eda1fa4
#git cherry-pick -m 1 7fedcbfa0f19
#git cherry-pick fbad6d17b0f6
#git cherry-pick -m 1 99bccff223ec
#git cherry-pick -m 1 dfeea547fff0
#git cherry-pick -m 1 e5b94a14f866

cd $BasePath
cd hardware/qcom/audio-caf/msm8994 
git fetch ~/git_Sandbox/Claymore1297/android_hardware_qcom_audio
git cherry-pick b479ecf731a3d6f2bd478d533e4b61e5d89c040c

#cd $BasePath
#cd frameworks/av
#git fetch ~/git_Sandbox/Claymore1297/android_frameworks_av
#git cherry-pick 170c8bb082a1a643073222a918a7024edd0b3b87

cd $BasePath
cd packages/apps/AICP_OTA 
git fetch ~/git_Sandbox/Claymore1297/packages_apps_AICP_OTA
git cherry-pick bc2878f9aad98ba0b64b08889f313528e86b6a1d  


cd $BasePath

fi

if [ "$LOS_BUILD" == "1" ];then
        export RELEASE_TYPE=AICP_WEEKLY
	brunch $Device
#	getZip=$(ls -la out/target/product/$Device | grep .zip | wc -l)
#	if [ $getZip == 0 ];then
#	echo -e "INFO\t2. Versuch ..."
#	brunch $Device
#	fi
fi
BUILD_RC=$?
echo -e "INFO\tRC: $BUILD_RC"
if [ "$LOS_ADDROM" == "1" ] && [ $BUILD_RC == "0" ];then
	addrom-aicp.sh 13.1 $Device
else
	echo -e "INFO\tBuild wird NICHT im Updater registriert"
fi

$BasePath/prebuilts/sdk/tools/jack-admin list-server && $BasePath/prebuilts/sdk/tools/jack-admin kill-server
exit 0
