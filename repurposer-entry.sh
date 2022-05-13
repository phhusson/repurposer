#!/system/bin/sh

p="/data/unencrypted/repurposer"
newhash=$(cat /data/unencrypted/repurposer.tar.gz.md5)


# For maintainance purposes we might want repurposer not to start
if [ -f /data/unencrypted/repurposer/stop ];then
    sleep infinity
    exit 0
fi

if [ "$newhash" != "$(cat $p/current.md5)" ];then
	rm -Rf $p
	mkdir -p $p
	tar xf /data/unencrypted/repurposer.tar.gz -C $p
    echo $newhash > $p/current.md5
fi

mount -o bind /dev "$p"/dev
mount -t proc none "$p"/proc
mount -t sysfs none "$p"/sys
mount -t devpts none "$p"/dev/pts

mkdir -p "$p"/android-shared
mount -o bind /data/media/0 "$p"/android-shared

mkdir -p "$p"/upgrade
mount -o bind /data/unencrypted/ "$p"/upgrade

chroot "$p" /bin/bash -x /run.sh
