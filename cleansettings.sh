#!/sbin/sh

echo -n "" > /system/freecyngn
chmod 644 /system/freecyngn

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
	echo "Patch framework incomplete, can't continue!" >> /system/freecyngn
	exit
fi

export SETTINGS_APP=/system/app/Settings.apk

if ! [ -f $SETTINGS_APP ]
then
	export SETTINGS_APP=/system/priv-app/Settings.apk
fi

if ! [ -f $SETTINGS_APP ]
then
	echo "Did not find Settings.apk on /system, is any ROM installed?" >> /system/freecyngn
	exit
fi

echo "Creating directory structure..." >> /system/freecyngn
rm -rf $BASE_DIR/Settings
rm -rf $BASE_DIR/noAnalytics

# ensure dalvik-cache exists
mkdir -p /cache/dalvik-cache
mkdir -p /cache/dalvik-cache
mkdir -p $BASE_DIR/Settings/smali
mkdir -p $BASE_DIR/noAnalytics/smali/com/google/analytics/tracking/android

echo "Extracting classes.dex from files..." >> /system/freecyngn
$BASE_DIR/busybox unzip $BASE_DIR/noAnalytics-dvk.jar classes.dex -d $BASE_DIR/noAnalytics >> /system/freecyngn || exit
$BASE_DIR/busybox unzip $SETTINGS_APP classes.dex -d $BASE_DIR/Settings >> /system/freecyngn || $BASE_DIR/busybox unzip $SETTINGS_APP classes.dex -d $BASE_DIR/Settings >> /system/freecyngn || exit

echo "Disassemble classes.dex..." >> /system/freecyngn
dalvikvm -cp $BASE_DIR/baksmali-dvk.jar org.jf.baksmali.main -o $BASE_DIR/Settings/smali $BASE_DIR/Settings/classes.dex >> /system/freecyngn || exit
dalvikvm -cp $BASE_DIR/baksmali-dvk.jar org.jf.baksmali.main -o $BASE_DIR/noAnalytics/smali $BASE_DIR/noAnalytics/classes.dex >> /system/freecyngn || exit

echo "Remove old Google Analytics..." >> /system/freecyngn
rm -rf $BASE_DIR/Settings/smali/com/google/analytics
rm -rf $BASE_DIR/Settings/smali/com/google/android/gms

echo "Insert noAnalytics..." >> /system/freecyngn
cp -r $BASE_DIR/noAnalytics/smali $BASE_DIR/Settings

echo "Reassembling classes.dex..." >> /system/freecyngn
rm $BASE_DIR/Settings/classes.dex
dalvikvm -Xmx256m -cp $BASE_DIR/smali-dvk.jar org.jf.smali.main  -o $BASE_DIR/Settings/classes.dex $BASE_DIR/Settings/smali >> /system/freecyngn || exit

echo "Adding new classes.dex to Settings.apk..." >> /system/freecyngn
cd $BASE_DIR/Settings
echo classes.dex | zip -0 -@ $SETTINGS_APP >> /system/freecyngn || exit

echo >> /system/freecyngn
echo "done" >> /system/freecyngn

echo "Have fun!"
