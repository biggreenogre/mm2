Add Recognition of Apple Magic Mouse 2 to Ubuntu Trusty

*** NOTE: These tools will NOT provide full touch support. The MM2 will still function as a basic 2-button mouse! ***
... but it WILL be using the hid_magicmouse module.

This works and is tested on Ubuntu Trusty (14.04) LTS but should work on most Debian-based distros and others with changes to the method of installing the kernel soyurce.

Files:
  21-apple-magicmouse-vendor-model.hwdb  -  The hardware db for udev with new vendor and device ids
  hid-ids.diff                           -  A patch to add the new vendor and device ids as HID devices
  hid-magicmouse.diff                    -  A patch to allow the hid_magicmouse module to recognise the Magic Mouse 2
  magicmouse2_build.sh                   -  Script to build and install the updated module and config files
  magicmouse2.conf                       -  The modprobe alias file for the Magic Mouse 2
  README                                 -  This file



In order for the system to recognise the Apple Magic Mouse 2 as a Magic device, we need to ...

  1. Pair the Magic Mouse to the system using the usual Bluetooth methods.
  2. Add the new vendor_id and device_id to the modprobe config and the udev hwdb.
  3. Patch the current hid_magicmouse kernel module and hid-ids header to recognise the new vendor and device ids.
  4. Load (or reload) the hid_magicmouse module after the update.

After step 1, run "./magicmouse2_build.sh" to perform steps 2 through 4.

ToDo:

Figure out how to convince the mouse to enable touch features.



Notes:

Device aliases for original Magic Mouse and Trackpad:-

Magic Trackpad: 
alias hid:b0005g*v000005ACp0000030E hid_magicmouse

Magic Mouse: 
alias hid:b0005g*v000005ACp0000030D hid_magicmouse

Magic Mouse 2: 
alias hid:b0005g*v0000004Cp00000269 hid_magicmouse


Output of lsinput for MM2:-
 /dev/input/event3
   bustype : BUS_BLUETOOTH
   vendor  : 0x4c
   product : 0x269
   version : 100
   name    : "Magic Mouse 2"
   phys    : "xx:xx:xx:xx:xx:xx"
   uniq    : "xx:xx:xx:xx:xx:xx"
   bits ev : EV_SYN EV_KEY EV_REL EV_ABS EV_MSC

