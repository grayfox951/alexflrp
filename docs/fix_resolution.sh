#!/bin/bash
echo "Mounting RootFS"
mount /data/rootfs.img /mnt
touch /mnt/usr/lib/systemd/system/ipafw.service
echo "Installing SIM patch..."
echo '[Unit]
Description=Load IPA firmware
After=lxc@android.service

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c "echo 1 > /dev/ipa"

[Install]
WantedBy=multi-user.target
' >> /mnt/usr/lib/systemd/system/ipafw.service
chroot /mnt  /usr/bin/systemctl mask systemd-journald ; chroot /mnt /usr/bin/systemctl mask udisks2 ; chroot /mnt /usr/bin/systemctl enable ipafw
chroot /mnt /bin/echo "#[core]
#xwayland=false

[output:DSI-1]
scale = 1.8

[output:HWCOMPOSER-1]
scale = 1.8

[output:Virtual-1]
# For the x86 VM using QXL to get a phone like geometry
modeline = 87.25  720 776 848 976  1440 1443 1453 1493 -hsync +vsync
mode = 720x1440
scale = 1.8

[output:X11-1]
mode = 360x720
#rotate = 90
scale = 1.8

[output:WL-1]
mode = 360x720
#rotate = 90
scale = 1.8" >> /mnt/usr/share/phosh/phoc.ini
umount /mnt
echo "Done!"
echo "Now reboot your mobile phone."
