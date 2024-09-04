#!/bin/bash
# shellcheck disable=SC1091,SC2154
set -x
source /etc/profile
source /root/.bashrc
source /root/.bash_profile
source /tmp/globe.common.conf
source /tmp/.private.sh
mkdir -p /var/lib/tftpboot/images

function check_distro {
    if ! ls /var/www/html/EL7-x86_64/Packages/centos-release-7-*.el7.centos.x86_64.rpm &>/dev/null; then
        rm -vf /var/lib/cobbler/collections/{distros,profiles}/EL7-x86_64.json
    fi
    if ! ls /var/www/html/EL7-aarch64/Packages/centos-release-7-*.el7.centos.a.aarch64.rpm &>/dev/null; then
        rm -vf /var/lib/cobbler/collections/{distros,profiles}/EL7-aarch64-aarch64.json
    fi
    if ! ls /var/www/html/FHOS-x86_64/Packages/FitStarrySkyOS-release-22.06.1-*.x86_64.rpm &>/dev/null; then
        rm -vf /var/lib/cobbler/collections/{distros,profiles}/FHOS-x86_64.json
    fi
    if ! ls /var/www/html/FHOS-aarch64/Packages/FitStarrySkyOS-release-22.06.1-*.aarch64.rpm &>/dev/null; then
        rm -vf /var/lib/cobbler/collections/{distros,profiles}/FHOS-aarch64-aarch64.json
    fi
    systemctl restart cobblerd
    sleep 10
    if systemctl status cobblerd; then
        echo "删除完不存在的系统配置后, cobberd 启动了"
    fi
    if ls /var/www/html/EL7-x86_64/Packages/centos-release-7-*.el7.centos.x86_64.rpm; then
        cobbler distro edit --name EL7-x86_64 --autoinstall-meta=tree=http://cobbler_ip/EL7-x86_64/
    fi
    if ls /var/www/html/EL7-aarch64/Packages/centos-release-7-*.el7.centos.a.aarch64.rpm; then
        cobbler distro edit --name EL7-aarch64-aarch64 --autoinstall-meta=tree=http://cobbler_ip/EL7-aarch64/
    fi
    if ls /var/www/html/FHOS-x86_64/Packages/FitStarrySkyOS-release-22.06.1-*.x86_64.rpm; then
        cobbler distro edit --name FHOS-x86_64 --autoinstall-meta=tree=http://cobbler_ip/FHOS-x86_64/
    fi
    if ls /var/www/html/FHOS-aarch64/Packages/FitStarrySkyOS-release-22.06.1-*.aarch64.rpm; then
        cobbler distro edit --name FHOS-aarch64-aarch64 --autoinstall-meta=tree=http://cobbler_ip/FHOS-aarch64/
    fi
}

if ! systemctl status httpd; then
    systemctl start httpd
    sleep 10
fi
systemctl disable --now dhcpd
pkill -f /usr/bin/cobblerd

ok_flag=0
while [[ ${ok_flag} -eq 0 ]]; do
    check_distro
    systemctl restart cobblerd
    sleep 10 && cobbler sync
    if cobbler distro report | grep cobbler_ip; then
        ok_flag=1
    fi
done

systemctl restart cobblerd dhcpd

if systemctl status dhcpd cobblerd httpd; then
    if sleep 10 && cobbler sync; then
        echo 1 >/tmp/tsc_cobbler_status
    fi
fi
