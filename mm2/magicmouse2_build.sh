#!/bin/bash

BUILD_ROOT=$(pwd)
KRNL_REL="$(uname -r)"
KRNL_VER="$(uname -r | cut -d\- -f1)"

# Extract the patch and udev files
# tar -xzvf magicmouse2_hack.tar.gz

# Make build dir, module backup dir and source dir
mkdir ./{hid.dist,dist_src}

# Get the source
cd dist_src
apt-get source linux

cd ${BUILD_ROOT}

# Backup existing hid modules
cp -rp /lib/modules/${KRNL_REL}/kernel/drivers/hid/* hid.dist

# Copy source to build dir
cp -rp dist_src/linux-${KRNL_VER}/drivers/hid .

cd hid

# Patch source
patch hid-ids.h < ../hid-ids.diff
patch hid-core.c < ../hid-core.diff
patch hid-magicmouse.c < ../hid-magicmouse.diff

# Compile new hid modules
make -C /lib/modules/${KRNL_REL}/build M=$(pwd) modules

# Install (to /lib/modules/$(uname -r)/extra/)
sudo make -C /lib/modules/${KRNL_REL}/build M=$(pwd) modules_install

cd ${BUILD_ROOT}

# Remove current hid modules and replace with new
sudo rm -rf /lib/modules/${KRNL_REL}/kernel/drivers/hid/*
sudo cp -rp /lib/modules/${KRNL_REL}/extra/*  /lib/modules/$(uname -r)/kernel/drivers/hid/

# Install the modprobe conf file
sudo cp magicmouse2.conf /etc/modprobe.d/

# Install the udev hwdb
sudo cp 21-apple-magicmouse-vendor-model.hwdb /etc/udev/hwdb.d

# Unload the old hid_magicmouse module
if `lsmod | grep -q hid_magicmouse`; then
  sudo modprobe -r hid_magicmouse || ( printf "\nMagicmouse module unload failed. Magic Mouse/Trackpad in use?\n" ; exit 1; )
fi

# Load new module
sudo modprobe hid_magicmouse || ( printf "\nMagicmouse module failed to load. Time to debug?\n"; exit 1; )

# Test that device is recognised as input device
sudo lsinput | grep -q Magic\ Mouse\ 2 && ( printf "\nNew magicmouse module ready for testing.\nNow go figure how to make the scroll and middle button emulation work!\n"; exit 0; ) || ( printf "\nMagicmouse module loaded but no MM2 input device detected. Check udev hwdb for MM2 exists in /etc/udev/hwdb.d/\n"; exit 1; )






