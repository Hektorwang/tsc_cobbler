# graphical
# network --bootproto=dhcp --device=bootif --onboot=on
$SNIPPET('network_config')
$yum_repo_stanza
eula --agreed
firewall --disabled
firstboot --disable
keyboard --vckeymap=us --xlayouts='us'
lang en_US.UTF-8
logging --level=info
reboot
rootpw --iscrypted $default_password_crypted
selinux --disable
services --disabled="chronyd"
skipx
text
timezone Asia/Shanghai --isUtc --nontp
url --url=$tree

bootloader --location=mbr
zerombr
clearpart --all --initlabel
part /boot --asprimary --fstype=xfs --size=1024
part swap --fstype=swap --size=8192
part / --fstype=xfs --grow

%pre
$SNIPPET('log_ks_pre')
$SNIPPET('autoinstall_start')
$SNIPPET('pre_install_network_config')
$SNIPPET('pre_anamon')
curl http://@@http_server@@/cblr/pub/custom_os_disk_config -o /tmp/custom_os_disk_config
if [[ -d /sys/firmware/efi ]] ; then
    echo "part /boot/efi --asprimary --fstype="xfs" --size=1024" >> /tmp/custom_os_disk_config
    echo "part biosboot --asprimary --fstype=biosboot --size=1" >> /tmp/custom_os_disk_config
fi
# curl http://@@http_server@@/cblr/pub/EL7.rpmlist -o /tmp/EL7.rpmlist
curl http://@@http_server@@/cblr/pub/custom_post_config.sh -o /tmp/custom_post_config.sh
%end

%include /tmp/custom_os_disk_config

%packages
@^StarrySky-default-environment
%end

%addon com_redhat_kdump --disable --reserve-mb='128'
%end

%post --nochroot
$SNIPPET('log_ks_post_nochroot')
%end

%post
$SNIPPET('log_ks_post')
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
%include /tmp/custom_post_config.sh
systemctl set-default multi-user.target
$SNIPPET('post_anamon')
$SNIPPET('autoinstall_done')
%end
