freecyngn
=========

A small tool to remove proprietary parts from CyanogenMod.

Usage
-----
1.	Build or [download](https://github.com/mar-v-in/freecyngn/releases) a cwm-compatible, 
	flashable zip file.
2.	Copy the zip file to the sdcard of your android device
3.	Boot your device into recovery.
4.	If not already done, install CyanogenMod as usual from recovery - DO NOT REBOOT
5.	Install freecyngn as if it was a rom, but DO NOT WIPE /system before
6.	Make sure there is no error output in /system/freecyngn/log

Note: You need to repeat step 5 everytime you update CyanogenMod. Do not use the CMUpdater,
as it will reboot the recovery after the update without giving you the choice to reflash 
freecyngn.

How it works
------------
freecyngn disassembles (using [bak]smali) the CyanogenMod settings app and removes
the proprietary Google Analytics component. It then replaces it with 
[NoAnalytics](https://github.com/mar-v-in/NoAnalytics), so that existing
bindings from cmstats do not break and reassembles the settings app.

freecyngn also removes CMAccount and Voice+ which either contain or require
proprietary components of Google.


Building
--------

###Prerequisites

- busybox:
	- src: https://github.com/linusyang/android-busybox-ndk
	- bin: https://code.google.com/p/yangapp/downloads/detail?name=busybox-1.21.1
- smali/baksmali: 
	- src: https://bitbucket.org/JesusFreke/smali/src
	- bin: https://bitbucket.org/JesusFreke/smali/downloads
- update-binary:
	- src: android source ( eg: https://github.com/CyanogenMod/android_bootable_recovery )
	- bin: http://www.mediafire.com/download/k1gwn6rmbhc491w/update-binary
- noAnalytics:
	- src: https://github.com/mar-v-in/NoAnalytics

###Instructions

1.	Create dexed versions of smali.jar, baksmali.jar and noAnalytics.jar by 
	calling	`dx --dex --output=file-dvk.jar file.jar`	for each of those files
2.	Create a flashable zip file using using the given updater-script
3.	In the newly created zip file, create a folder freecyngn on /
4.	Copy busybox binary, the three *-dvk.jar files and the *.sh files in the zips subfolder
5.	You're done
