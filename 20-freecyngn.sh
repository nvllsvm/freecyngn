#!/sbin/sh
#
# /system/addon.d/20-freecyngn.sh
# During a CM10+ upgrade this script repatches CyanogenMod
# using the freecyngn patchset.
#

. /tmp/backuptool.functions

list_files() {
cat <<EOF
freecyngn/freecyngn.sh
freecyngn/noAnalytics-dvk.jar
freecyngn/baksmali-dvk.jar
freecyngn/smali-dvk.jar
freecyngn/busybox
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/"$FILE"
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/"$FILE" "$R"
    done
    chmod 755 /system/freecyngn/busybox
    chmod 755 /system/freecyngn/freecyngn.sh
    /system/freecyngn/freecyngn.sh
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Stub
  ;;
esac
