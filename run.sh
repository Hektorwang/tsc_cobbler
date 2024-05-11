#!/bin/bash
# shellcheck disable=SC1090,SC1091,SC2154
set +o posix

BASE_DIR=$(
    cd "$(dirname "$0")" || exit 99
    pwd
)
script_name="$(basename "$0")"
log_file="${BASE_DIR}"/log/"${script_name}".log

source "${BASE_DIR}"/lib/func
source "${BASE_DIR}"/globe.common.conf
source "${BASE_DIR}"/.private.sh

rootfs="${BASE_DIR}"/container

function check_env {
    LOGINFO "${FUNCNAME[0]}"
    local requirements_lacks dup_ports protocol

    if [[ $(id -u) -ne 0 ]]; then
        LOGERROR This tool must be run as root.
        exit 11
    fi

    requirements_lacks=()
    for requirement in "${!requirements[@]}"; do
        if ! command -v "${requirement}" &>/dev/null; then
            requirements_lacks+=("${requirements[$requirement]}")
        fi
    done
    if [[ ${#requirements_lacks[@]} -gt 0 ]]; then
        LOGERROR "Requirements not installed: ${requirements_lacks[*]}"
        exit 12
    fi

    dup_ports=()
    for port in "${!ports[@]}"; do
        protocol="${ports[$port]%%:*}"
        if lsof -nP -s"${protocol}":LISTEN -i"${ports[$port]}" &>/dev/null; then
            dup_ports+=("${port}->${ports[$port]}")
        fi
    done
    if [[ ${#dup_ports[@]} -gt 0 ]]; then
        LOGERROR "Ports occupied: ${dup_ports[*]}"
        exit 13
    fi

    if [[ ! -d "${rootfs}" ]]; then
        LOGERROR "Not exist: ${rootfs}"
        exit 14
    fi

    if [[ -z "${root_passwd}" ]]; then
        LOGERROR "Need config: root_passwd"
        exit 15
    fi

    if ! is_ip_in_network "$(echo "${dhcp_range}" | cut -d' ' -f1)" "${cobbler_ip}" "${cobbler_netmask}"; then
        exit 16
    fi
    if ! is_ip_in_network "$(echo "${dhcp_range}" | cut -d' ' -f2)" "${cobbler_ip}" "${cobbler_netmask}"; then
        exit 17
    fi

    mounted_cnt=0
    if ls "${BASE_DIR}"/EL7-x86_64/Packages/centos-release-7-*.el7.centos.x86_64.rpm &>/dev/null; then
        LOGSUCCESS "已挂载 EL7-x86_64 ISO 到 ${BASE_DIR}/EL7-x86_64"
        \cp "${BASE_DIR}"/etc/distros/EL7-x86_64.json "${rootfs}"/var/lib/cobbler/collections/distros/
        \cp "${BASE_DIR}"/etc/profiles/EL7-x86_64.json "${rootfs}"/var/lib/cobbler/collections/profiles/
    else
        LOGWARNING "未挂载 EL7-x86_64 ISO 到 ${BASE_DIR}/EL7-x86_64", 将无法提供该操作系统远程安装服务
        ((mounted_cnt++))
    fi
    if ls "${BASE_DIR}"/EL7-aarch64/Packages/centos-release-7-*.el7.centos.a.aarch64.rpm &>/dev/null; then
        LOGSUCCESS "已挂载 EL7-aarch64 ISO 到 ${BASE_DIR}/EL7-aarch64"
        \cp "${BASE_DIR}"/etc/distros/EL7-aarch64-aarch64.json "${rootfs}"/var/lib/cobbler/collections/distros/
        \cp "${BASE_DIR}"/etc/profiles/EL7-aarch64-aarch64.json "${rootfs}"/var/lib/cobbler/collections/profiles/
    else
        LOGWARNING "未挂载 EL7-aarch64 ISO 到 ${BASE_DIR}/EL7-aarch64", 将无法提供该操作系统远程安装服务
        ((mounted_cnt++))
    fi
    if ls "${BASE_DIR}"/FHOS-x86_64/Packages/FitStarrySkyOS-release-22.06.1-*.x86_64.rpm &>/dev/null; then
        LOGSUCCESS "已挂载 FHOS-x86_64 ISO 到 ${BASE_DIR}/ FHOS-x86_64"
        \cp "${BASE_DIR}"/etc/distros/FHOS-x86_64.json "${rootfs}"/var/lib/cobbler/collections/distros/
        \cp "${BASE_DIR}"/etc/profiles/FHOS-x86_64.json "${rootfs}"/var/lib/cobbler/collections/profiles/
    else
        LOGWARNING "未挂载 FHOS-x86_64 ISO 到 ${BASE_DIR}/FHOS-x86_64", 将无法提供该操作系统远程安装服务
        ((mounted_cnt++))
    fi
    if ls "${BASE_DIR}"/FHOS-aarch64/Packages/FitStarrySkyOS-release-22.06.1-*.aarch64.rpm &>/dev/null; then
        LOGSUCCESS "已挂载 FHOS-aarch64 ISO 到 ${BASE_DIR}/ FHOS-aarch64"
        \cp "${BASE_DIR}"/etc/distros/FHOS-aarch64-aarch64.json "${rootfs}"/var/lib/cobbler/collections/distros/
        \cp "${BASE_DIR}"/etc/profiles/FHOS-aarch64-aarch64.json "${rootfs}"/var/lib/cobbler/collections/profiles/
    else
        LOGWARNING "未挂载 FHOS-aarch64 ISO 到 ${BASE_DIR}/FHOS-aarch64", 将无法提供该操作系统远程安装服务
        ((mounted_cnt++))
    fi
    if [[ ${mounted_cnt} -eq 4 ]]; then
        LOGERROR 未挂载任何操作系统镜像, 无法提供安装服务.
        exit 18
    fi

    if [[ $(getenforce) != Disabled ]]; then
        LOGERROR "SELinux is not disabled"
        exit 19
    fi

    if command -v iptables-save &>/dev/null; then
        if [[ $(iptables-save | wc -l) -gt 0 ]]; then
            LOGERROR "iptables have rules，delete them and retry."
            exit 19
        fi
    fi

    if command -v nft &>/dev/null; then
        if [[ $(nft list tables | wc -l) -gt 0 ]]; then
            LOGERROR "nftables have rules, delete them and retry."
            exit 19
        fi
    fi

    LOGSUCCESS "${FUNCNAME[0]}"
}

function config_nic {
    LOGINFO "${FUNCNAME[0]}"
    cobbler_netprefix="$(ipcalc -p "${cobbler_ip}" "${cobbler_netmask}" | cut -d'=' -f2)"
    cobbler_network=$(ipcalc -n "${cobbler_ip}" "${cobbler_netmask}" | cut -d'=' -f2)
    export cobbler_netprefix cobbler_network
    {
        ifconfig "${cobbler_nic}" down
        ifconfig "${cobbler_nic}" "${cobbler_ip}"/"${cobbler_netprefix}"
        ifconfig "${cobbler_nic}" up
    } 2>&1 | tee -a" ${log_file}"
    if ifconfig "${cobbler_nic}" 2>&1 | grep -qP "^\s*inet\s+${cobbler_ip}\s*netmask\s+${cobbler_netmask}"; then
        LOGSUCCESS "${FUNCNAME[0]}"
    else
        LOGERROR "${FUNCNAME[0]}"
        exit 21
    fi
}

function config_container {
    LOGINFO "${FUNCNAME[0]}"
    local hashed_passwd output_file
    hashed_passwd="$(openssl passwd -1 "${root_passwd}")"
    # if ! systemd-nspawn --register=no -D "${rootfs}" \
    #    --setenv=root_passwd="${root_passwd}" \
    #    -- /bin/bash -c "echo \"${root_passwd}\" | passwd --stdin root" &>>"${log_file}"; then
    #    LOGERROR systemd-nspawn --register=no -D "${rootfs}" \
    #        --setenv=root_passwd="${root_passwd}" \
    #        -- /bin/bash -c "echo \"${root_passwd}\" | passwd --stdin root"
    #    LOGERROR "${FUNCNAME[0]}"
    #    exit 31
    # fi

    output_file="${BASE_DIR}"/container/var/www/cobbler/pub/custom_os_disk_config
    mkdir -p "$(dirname "${output_file}")"
    if [[ -n "${sys_disk}" ]]; then
        echo "# This is a sample to define OS disk
ignoredisk --only-use=${sys_disk}" >"${output_file}"
    else
        LOGWARNING The sys_disk variable is undefined. OS will be installed on the first hard disk of the client device, which might cause data loss.
        : >"${output_file}"
    fi

    output_file="${BASE_DIR}"/etc/container/etc/cobbler/settings.d/tsc.settings
    mkdir -p "$(dirname "${output_file}")"
    echo "# tsc_cobbler
allow_dynamic_settings: true
anamon_enabled: true
default_password_crypted: \"${hashed_passwd}\"
manage_dhcp: true
manage_dhcp_v4: true
next_server_v4: ${cobbler_ip}
server: ${cobbler_ip}" >"${output_file}"

    output_file="${BASE_DIR}"/etc/container/etc/cobbler/dhcp.template
    mkdir -p "$(dirname "${output_file}")"
    sed -r "${BASE_DIR}"/etc/container/etc/cobbler/dhcp.template.tsc \
        -e "s/cobbler_network/${cobbler_network}/g" \
        -e "s/cobbler_netmask/${cobbler_netmask}/g" \
        -e "s/cobbler_ip/${cobbler_ip}/g" \
        -e "s/dhcp_range/${dhcp_range}/g" \
        -e "s/default_lease_time/${default_lease_time}/g" \
        -e "s/max_lease_time/${max_lease_time}/g" >"${output_file}"

    output_file="${BASE_DIR}"/tmp/init.sh
    sed "s/cobbler_ip/${cobbler_ip}/g" "${BASE_DIR}"/etc/init.sh >"${output_file}"
    chmod a+x "${output_file}"
    LOGSUCCESS "${FUNCNAME[0]}"
}

function start_container {
    LOGINFO "${FUNCNAME[0]}"
    LOGINFO "开启 cobbler 服务, 可能需要数分钟, 请稍候..."
    : >"${BASE_DIR}"/log/cobbler_start.log
    : >"${BASE_DIR}"/tmp/tsc_cobbler_status
    screen -dmS tsc_cobbler_container systemd-nspawn --register=no -qbD "${rootfs}" \
        --bind-ro="${BASE_DIR}"/etc/container/var/lib/cobbler/distro_signatures.json.tsc:/var/lib/cobbler/distro_signatures.json \
        --bind-ro="${BASE_DIR}"/etc/container/etc/cobbler/dhcp.template:/etc/cobbler/dhcp.template \
        --bind-ro="${BASE_DIR}"/etc/container/etc/cobbler/settings.d/tsc.settings:/etc/cobbler/settings.d/tsc.settings \
        --bind-ro="${BASE_DIR}"/globe.common.conf:/tmp/globe.common.conf \
        --bind-ro="${BASE_DIR}"/.private.sh:/tmp/.private.sh \
        --bind-ro="${BASE_DIR}"/tmp/init.sh:/tmp/init.sh \
        --bind="${BASE_DIR}"/tmp/tsc_cobbler_status:/tmp/tsc_cobbler_status \
        --bind="${BASE_DIR}"/log/cobbler_start.log:/tmp/cobbler_start.log \
        --bind-ro="${BASE_DIR}"/"${EL7__x86_64[0]}-${EL7__x86_64[1]}":"/var/www/html/${EL7__x86_64[0]}-${EL7__x86_64[1]}" \
        --bind-ro="${BASE_DIR}"/"${EL7__aarch64[0]}-${EL7__aarch64[1]}":"/var/www/html/${EL7__aarch64[0]}-${EL7__aarch64[1]}" \
        --bind-ro="${BASE_DIR}"/"${FHOS__x86_64[0]}-${FHOS__x86_64[1]}":"/var/www/html/${FHOS__x86_64[0]}-${FHOS__x86_64[1]}" \
        --bind-ro="${BASE_DIR}"/"${FHOS__aarch64[0]}-${FHOS__aarch64[1]}":"/var/www/html/${FHOS__aarch64[0]}-${FHOS__aarch64[1]}" # \
    # &>>"${log_file}"

    cobbler_boot_flag=0
    for dot_cnt in {1..120}; do
        if grep -q 1 "${BASE_DIR}"/tmp/tsc_cobbler_status &>/dev/null; then
            cobbler_boot_flag=1
            break
        else
            sleep 5
            echo -en "\033[2K\r$(printf '.%.0s' $(seq 1 "${dot_cnt}"))"
        fi
    done
    echo -en "\033[2K\r"
    if [[ ${cobbler_boot_flag} -eq 0 ]]; then
        LOGERROR "启动失败, 请参考 readme.md 排查"
        exit 41
    else
        LOGSUCCESS "${FUNCNAME[0]}"
    fi
}

LOGINFO start
if pgrep -f "systemd-nspawn --register=no" &>/dev/null; then
    LOGWARNING 已启动 tsc_cobbler, 将在 10 秒内结束已启动的 tsc_cobbler, 如需保留现有服务请在 10 秒内按 ctrl + c
    # pgrep -alf "systemd-nspawn --register=no --machine=tsc_cobbler"
    for dot_cnt in {10..1}; do
        sleep 1
        echo -en "\033[2K\r$(printf '.%.0s' $(seq 1 "${dot_cnt}"))"
    done
    echo -en "\033[2K\r"
    screen -S tsc_cobbler_container -R -X quit
    mapfile -t pids < <(pgrep -f "systemd-nspawn --register=no --machine=tsc_cobbler")
    for pid in "${pids[@]}"; do
        kill -9 "${pid}" &>/dev/null
    done
    screen -wipe
fi
check_env
config_nic
config_container
start_container
