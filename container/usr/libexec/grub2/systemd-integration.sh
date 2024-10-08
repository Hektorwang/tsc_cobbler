#!/usr/bin/sh

TIMEOUT_USEC=$(cat /run/systemd/reboot-to-boot-loader-menu)
TIMEOUT=$(((TIMEOUT_USEC + 500000) / 1000000))

grub2-editenv - set menu_show_once_timeout=$TIMEOUT

# Downstream RH / Fedora patch for compatibility with old, not (yet)
# regenerated grub.cfg files which miss the menu_show_once_timeout check
# this older grubenv variable leads to a fixed timeout of 60 seconds
grub2-editenv - set menu_show_once=1
