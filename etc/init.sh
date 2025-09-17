#!/bin/bash
# shellcheck disable=SC1091,SC2154
set -x
source /etc/profile
source /root/.bashrc
source /root/.bash_profile
source /tmp/globe.common.conf
source /tmp/.private.sh
mkdir -p /var/lib/tftpboot/images

check_distro() {
    # 目录名|rpm匹配|json名|cobbler name
    local os_images=(
        "EL7-x86_64|centos-release-7-*.el7.centos.x86_64.rpm|EL7-x86_64.json|EL7-x86_64"
        "EL7-aarch64|centos-release-7-*.el7.centos.a.aarch64.rpm|EL7-aarch64-aarch64.json|EL7-aarch64-aarch64"
        "FHOS-x86_64|FitStarrySkyOS-release-22.06.1-*.x86_64.rpm|FHOS-x86_64.json|FHOS-x86_64"
        "FHOS-aarch64|FitStarrySkyOS-release-22.06.1-*.aarch64.rpm|FHOS-aarch64-aarch64.json|FHOS-aarch64-aarch64"
        "Euler-x86_64|openEuler-release-*.x86_64.rpm|Euler-x86_64.json|Euler-x86_64"
        "Euler-aarch64|openEuler-release-*.aarch64.rpm|Euler-aarch64-aarch64.json|Euler-aarch64-aarch64"
    )
    echo "对于不存在的系统, 删除其distro和profile文件, 否则会导致 cobbler 不能启动"
    for os_info in "${os_images[@]}"; do
        IFS='|' read -r os_dir rpm_pattern json_name cobbler_name <<<"$os_info"
        # if ! ls "/var/www/html/${os_dir}/Packages/${rpm_pattern}" &>/dev/null; then
        if [[ -z "$(
            find "/var/www/html/${os_dir}/Packages/" -type f -name "${rpm_pattern}" 2>/dev/null
        )" ]]; then
            rm -f /var/lib/cobbler/collections/{distros,profiles}/"${json_name}"
        fi
    done
    systemctl restart cobblerd
    sleep 10
    if systemctl status cobblerd; then
        echo "删除完不存在的系统配置后, cobberd 启动了"
    fi
    for os_info in "${os_images[@]}"; do
        IFS='|' read -r os_dir rpm_pattern json_name cobbler_name <<<"$os_info"
        # if ls "/var/www/html/${os_dir}/Packages/${rpm_pattern}" 2>/dev/null; then
        if [[ -n "$(
            find "/var/www/html/${os_dir}/Packages/" -type f -name "${rpm_pattern}" 2>/dev/null
        )" ]]; then
            echo "开始修改 ${cobbler_name}"
            echo "cobbler distro edit --name ${cobbler_name} --autoinstall-meta=tree=http://cobbler_ip/${os_dir}/"
            cobbler distro edit --name "${cobbler_name}" --autoinstall-meta=tree="http://cobbler_ip/${os_dir}"/ &&
                echo "完成修改 ${cobbler_name}"
        fi
    done
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
    sleep 30 && cobbler sync
    cobbler distro report
    if cobbler distro report | grep "cobbler_ip"; then
        ok_flag=1
    fi
done

systemctl restart cobblerd dhcpd

if systemctl status dhcpd cobblerd httpd; then
    if sleep 30 && cobbler sync; then
        echo 1 >/tmp/tsc_cobbler_status
    fi
fi
