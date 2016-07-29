#!/sbin/sh
#
# /system/addon.d/20-freecyngn.sh
# During a CM10+ upgrade this script repatches CyanogenMod
# using the freecyngn patchset.
#

. /tmp/backuptool.functions

deleteApk() {
    rm -rf /system/app/$1.apk /system/priv-app/$1.apk /system/app/$1 /system/priv-app/$1 && echo "Removed $1"
}

del_files() {
cat <<EOF
Gello
CMAccount
CMS
CMSetupWizard
CyanogenSetupWizard
LockClock
TimeService
Voice+
VoiceDialer
VoicePlus
WhisperPush
EOF
}

if [[ "$1" == "post-restore" ]] || [[ "$1" == "" ]]; then
    del_files | while read FILE; do
        deleteApk "$FILE"
    done
fi
