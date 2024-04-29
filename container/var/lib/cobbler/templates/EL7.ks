install
keyboard 'us'
rootpw --iscrypted $default_password_crypted
lang en_US
auth --useshadow --enablemd5
text
firstboot --disable
selinux --disabled
services --disabled="chronyd"
skipx
firewall --disabled
timezone Asia/Shanghai --isUtc --nontp
network --bootproto=dhcp --device=bootif --onboot=on
url --url=$tree
reboot

bootloader --location=mbr
zerombr
clearpart --all --initlabel
part /boot --asprimary --fstype=xfs --size=1024
part swap --fstype=swap --size=8192
part / --fstype=xfs --grow

%pre
curl http://@@http_server@@/cblr/pub/custom_os_disk_config -o /tmp/custom_os_disk_config
if [[ -d /sys/firmware/efi ]] ; then
    echo "part /boot/efi --asprimary --fstype="xfs" --size=1024" >> /tmp/custom_os_disk_config
    echo "part biosboot --asprimary --fstype=biosboot --size=1" >> /tmp/custom_os_disk_config
fi
curl http://@@http_server@@/cblr/pub/EL7.rpmlist -o /tmp/EL7.rpmlist
curl http://@@http_server@@/cblr/pub/custom_post_config.sh -o /tmp/custom_post_config.sh
%end

%include /tmp/custom_os_disk_config

%packages
%include /tmp/EL7.rpmlist
%end

%post
%include /tmp/custom_post_config.sh
%end

