#!/bin/bash

[ ! -f NetInterpreter/app.apk ] && (
git clone https://github.com/phhusson/NetInterpreter
cd NetInterpreter
bash build.sh
)

# Reboot without running repurposer to be able to clean it
adb root
adb shell blockdev --setrw /dev/block/dm-0
adb shell blockdev --setrw /dev/tmp-phh
adb shell mount -o remount,rw /
adb shell mount -o remount,rw /system
adb shell touch /data/unencrypted/repurposer/stop
adb reboot

adb wait-for-device exec-out true
adb wait-for-device exec-out true
adb wait-for-device exec-out true
adb root
adb wait-for-device exec-out true
adb wait-for-device exec-out true
adb wait-for-device exec-out true
adb shell blockdev --setrw /dev/block/dm-0
adb shell blockdev --setrw /dev/tmp-phh
adb shell mount -o remount,rw /
adb shell mount -o remount,rw /system

adb exec-out rm -Rf /data/unencrypted/repurposer
adb push repurposer.rc /system/etc/init/repurposer.rc
adb push repurposer-entry.sh /system/bin/repurposer-entry.sh
while [ "$(adb exec-out getprop sys.boot_completed)" != 1 ] ;do sleep 1;done
adb install -r NetInterpreter/app.apk 
adb shell pm disable com.android.launcher3
adb shell cmd role add-role-holder android.app.role.HOME me.phh.netinterpreter
adb shell settings put secure doze_always_on 0
adb shell rm /data/unencrypted/repurposer/stop
adb reboot
