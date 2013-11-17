#!/sbin/sh

export PATH=/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:/sbin
export LD_LIBRARY_PATH=/vendor/lib:/system/lib:/lib:/sbin
export ANDROID_BOOTLOGO=1
export ANDROID_ROOT=/system
export ANDROID_ASSETS=/system/app
export ANDROID_DATA=/data
export ANDROID_STORAGE=/storage
export ASEC_MOUNTPOINT=/mnt/asec
export LOOP_MOUNTPOINT=/mnt/obb
export BOOTCLASSPATH=/system/framework/core.jar:/system/framework/conscrypt.jar:/system/framework/okhttp.jar:/system/framework/core-junit.jar:/system/framework/bouncycastle.jar:/system/framework/ext.jar:/system/framework/framework.jar:/system/framework/framework2.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/mms-common.jar:/system/framework/android.policy.jar:/system/framework/services.jar:/system/framework/apache-xml.jar:/system/framework/webviewchromium.jar

export BASE_DIR=/cache/recovery/freecyngn

if ! [ -f $BASE_DIR/busybox ] || ! [ -f $BASE_DIR/noAnalytics-dvk.jar ] || ! [ -f $BASE_DIR/baksmali-dvk.jar ] || ! [ -f $BASE_DIR/smali-dvk.jar ]
then
	echo "Patch framework incomplete, can't continue!"
	exit
fi

export SETTINGS_APP=/system/app/Settings.apk

if ! [ -f $SETTINGS_APP ]
then
	export SETTINGS_APP=/system/priv-app/Settings.apk
fi

if ! [ -f $SETTINGS_APP ]
then
	echo "Did not found Settings.apk on /system, is any ROM installed?"
	exit
fi

echo "Creating directory structure..."
rm -rf $BASE_DIR/Settings
rm -rf $BASE_DIR/noAnalytics

# ensure dalvik-cache exists
mkdir -p /cache/dalvik-cache
mkdir -p /cache/dalvik-cache
mkdir -p $BASE_DIR/Settings/smali
mkdir -p $BASE_DIR/noAnalytics/smali/com/google/analytics/tracking/android

echo "Extracting classes.dex from files..."
$BASE_DIR/busybox unzip $BASE_DIR/noAnalytics-dvk.jar classes.dex -d $BASE_DIR/noAnalytics
$BASE_DIR/busybox unzip $SETTINGS_APP classes.dex -d $BASE_DIR/Settings

echo "Disassemble classes.dex..."
dalvikvm -cp $BASE_DIR/baksmali-dvk.jar org.jf.baksmali.main -o $BASE_DIR/Settings/smali $BASE_DIR/Settings/classes.dex
dalvikvm -cp $BASE_DIR/baksmali-dvk.jar org.jf.baksmali.main -o $BASE_DIR/noAnalytics/smali $BASE_DIR/noAnalytics/classes.dex

echo "Remove old Google Analytics..."
rm -rf $BASE_DIR/Settings/smali/com/google/analytics
rm -rf $BASE_DIR/Settings/smali/com/google/android/gms

echo "Insert noAnalytics..."
cp -r $BASE_DIR/noAnalytics/smali $BASE_DIR/Settings

echo "Reassembling classes.dex..."
rm $BASE_DIR/Settings/classes.dex
dalvikvm -Xmx256m -cp $BASE_DIR/smali-dvk.jar org.jf.smali.main  -o $BASE_DIR/Settings/classes.dex $BASE_DIR/Settings/smali

echo "Adding new classes.dex to Settings.apk..."
cd $BASE_DIR/Settings
echo classes.dex | zip -0 -@ $SETTINGS_APP

echo "Have fun!"
