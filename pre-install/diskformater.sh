#!/bin/bash
# add formatdisks

		umount /data1 && \
        umount /data2 && \
        umount /data3 && \
        umount /data4 && \
        umount /data5 && \
        umount /data6 && \
        umount /data7 && \
        umount /data8 && \
        umount /data9 && \
        umount /data10 && \
		rmdir /data1 && \
        rmdir /data2 && \
        rmdir /data3 && \
        rmdir /data4 && \
        rmdir /data5 && \
        rmdir /data6 && \
        rmdir /data7 && \
        rmdir /data8 && \
        rmdir /data9 && \
        rmdir /data10 && \

	mkdir /data1 && \
	echo "," | parted -s  /dev/sdb mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sdb1 && \
	mount /data1 && \
	echo "formated and mounted /disk1"  && \

	mkdir /data2 && \
	echo "," | parted -s  /dev/sdc mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sdc1 && \
	mount /data2 && \
	echo "formated and mounted /disk2"  && \

	mkdir /data3 && \
	echo "," | parted -s  /dev/sdd mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sdd1 && \
	mount /data3 && \
	echo "formated and mounted /disk3"  && \

	mkdir /data4 && \
	echo "," | parted -s  /dev/sde mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sde1 && \
	mount /data4 && \
	echo "formated and mounted /disk4"  && \

	mkdir /data5 && \
	echo "," | parted -s  /dev/sdf mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sdf1 && \
	mount /data5 && \
	echo "formated and mounted /disk5"  && \

	mkdir /data6 && \
	echo "," | parted -s  /dev/sdg mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sdg1 && \
	mount /data6 && \
	echo "formated and mounted /disk6"  && \

	mkdir /data7 && \
	echo "," | parted -s  /dev/sdh mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sdh1 && \
	mount /data7 && \
	echo "formated and mounted /disk7"  && \

	mkdir /data8 && \
	echo "," | parted -s  /dev/sdi mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sdi1 && \
	mount /data8 && \
	echo "formated and mounted /disk8"  && \

	mkdir /data9 && \
	echo "," | parted -s  /dev/sdj mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sdj1 && \
	mount /data9 && \
	echo "formated and mounted /disk9"  && \

	mkdir /data10 && \
	echo "," | parted -s  /dev/sdk mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sdk1 && \
	mount /data10 && \
	echo "formated and mounted /disk10" 	
