Freecyngn
=========

A small tool to remove proprietary parts from Cyanogenmod


Prerequisites
-------------

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

Building
--------

1.	Create dexed versions of smali.jar, baksmali.jar and noAnalytics.jar by 
	calling	`dx --dex --output=file-dvk.jar file.jar`	for each of those files
2.	Create a flashable zip file using using the given updater-script
3.	In the newly created zip file, create a folder freecyngn on /
4.	Copy busybox binary, the three *-dvk.jar files and the cleansettings.sh in the zips subfolder
5.	You're done
