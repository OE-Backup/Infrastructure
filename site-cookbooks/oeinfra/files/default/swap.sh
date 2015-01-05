#! /bin/sh
### BEGIN INIT INFO
# Provides:           Swap-file into /mnt/swapfile
### END INIT INFO
#
dd if=/dev/zero of=/mnt/swapfile bs=1024 count=2097152
mkswap /mnt/swapfile
chmod 0600 /mnt/swapfile
swapon /mnt/swapfile