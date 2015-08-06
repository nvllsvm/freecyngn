freecyngn
=========

A small tool to remove some proprietary parts from CyanogenMod.

freecyngn removes the following components which either contain or require
proprietary components of Google:

- CMAccount
- CMS
- CMSetupWizard
- CyanogenSetupWizard
- LockClock
- Voice+
- VoiceDialer
- VoicePlus
- WhisperPush

Usage
-----

1. Build or download a cwm-compatible, flashable zip file.
2. Copy the zip file to the sdcard of your android device
3. Boot your device into recovery.
4. If not already done, install CyanogenMod as usual from recovery - DO NOT REBOOT
5. Install freecyngn as if it was a rom, but DO NOT WIPE /system before
6. Make sure there is no error output in /system/freecyngn/log

If you update CyanogenMod, freecyngn is automatically applied if it was before. 
However make sure to regularly check for freecyngn updates, as CM may change some things.

License
-------
freecyngn is licensed under WTFPL, see LICENSE
