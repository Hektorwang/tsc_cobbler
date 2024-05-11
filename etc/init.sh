#!/bin/bash
# shellcheck disable=SC1091,SC2154
set -x
source /tmp/globe.common.conf
source /tmp/.private.sh
mkdir -p /var/lib/tftpboot/images

function check_distro {
    if ls /var/www/html/EL7-x86_64/Packages/centos-release-7-*.el7.centos.x86_64.rpm; then
        cobbler distro edit --name EL7-x86_64 --autoinstall-meta=tree=http://cobbler_ip/EL7-x86_64/
    else
        rm -vf /var/lib/cobbler/collections/{distros,profiles}/EL7-x86_64.json
    fi
    if ls /var/www/html/EL7-aarch64/Packages/centos-release-7-*.el7.centos.a.aarch64.rpm; then
        cobbler distro edit --name EL7-aarch64-aarch64 --autoinstall-meta=tree=http://cobbler_ip/EL7-aarch64/
    else
        rm -vf /var/lib/cobbler/collections/{distros,profiles}/EL7-aarch64-aarch64.json
    fi
    if ls /var/www/html/FHOS-x86_64/Packages/FitStarrySkyOS-release-22.06.1-*.x86_64.rpm; then
        cobbler distro edit --name FHOS-x86_64 --autoinstall-meta=tree=http://cobbler_ip/FHOS-x86_64/
    else
        rm -vf /var/lib/cobbler/collections/{distros,profiles}/FHOS-x86_64.json
    fi
    if ! ls /var/www/html/FHOS-aarch64/Packages/FitStarrySkyOS-release-22.06.1-*.aarch64.rpm; then
        cobbler distro edit --name FHOS-aarch64-aarch64 --autoinstall-meta=tree=http://cobbler_ip/FHOS-aarch64/
    else
        rm -vf /var/lib/cobbler/collections/{distros,profiles}/FHOS-aarch64-aarch64.json
    fi
}

if ! systemctl status httpd; then
    systemctl start httpd
fi
systemctl disable --now dhcpd

ok_flag=0
# i=0
while [[ ${ok_flag} -eq 0 ]]; do
    # ((i++))
    check_distro
    systemctl restart cobblerd
    sleep 10
    cobbler sync
    if cobbler distro report | grep cobbler_ip; then
        ok_flag=1
    # cobbler mkloaders
    fi
done

systemctl restart cobblerd dhcpd

if systemctl status dhcpd cobblerd httpd; then
    if cobbler sync; then
        echo 1 >/tmp/tsc_cobbler_status
    fi
fi
