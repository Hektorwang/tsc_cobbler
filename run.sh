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

rootfs="${BASE_DIR}"/container

function check_env {
    LOGINFO "${FUNCNAME[0]}"
    if [[ $(id -u) -ne 0 ]]; then
        LOGERROR This tool must be run as root.
        exit 10
    fi
    local requirements_lacks requirement ports dup_ports
    requirements_lacks=()
    for requirement in "${requirements[@]}"; do
        if ! command -v "${requirement}" &>/dev/null; then
            requirements_lacks+=("${requirement}")
        fi
    done
    if [[ ${#requirements_lacks[@]} -gt 0 ]]; then
        LOGERROR "缺少依赖组件: ${requirements_lacks[*]}"
        exit 11
    fi
    dup_ports=()
    for port in "${ports[@]}"; do
        if [[ $(ss -lnoptu src ":${port}" | wc -l) -gt 1 ]]; then
            dup_ports+=("${port}")
        fi
    done
    if [[ ${#dup_ports[@]} -gt 0 ]]; then
        LOGERROR "端口被占用: ${dup_ports[*]}"
        exit 11
    fi
    if [[ ! -d "${rootfs}" ]]; then
        LOGERROR "缺少 cobbler 目录: ${rootfs}"
        exit 12
    fi
    if [[ -z "${root_passwd}" ]]; then
        LOGERROR "未配置: root_passwd"
        exit 13
    fi
    if ! is_ip_in_network "$(echo "${dhcp_range}" | cut -d' ' -f1)" "${cobbler_ip}" "${cobbler_netmask}"; then
        exit 14
    fi
    if ! is_ip_in_network "$(echo "${dhcp_range}" | cut -d' ' -f2)" "${cobbler_ip}" "${cobbler_netmask}"; then
        exit 14
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
        exit 15
    fi

    LOGSUCCESS "${FUNCNAME[0]}"
}

function config_nic {
    LOGINFO "${FUNCNAME[0]}"
    cobbler_netprefix="$(ipcalc -p "${cobbler_ip}" "${cobbler_netmask}" | cut -d'=' -f2)"
    cobbler_network=$(ipcalc -n "${cobbler_ip}" "${cobbler_netmask}" | cut -d'=' -f2)
    export cobbler_netprefix cobbler_network
    ifconfig "${cobbler_nic}" down
    ifconfig "${cobbler_nic}" "${cobbler_ip}"/"${cobbler_netprefix}"
    ifconfig "${cobbler_nic}" up
    if ifconfig "${cobbler_nic}" | grep -qP "^\s*inet\s+${cobbler_ip}\s*netmask\s+${cobbler_netmask}"; then
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
    echo "# This is a sample to define OS disk
ignoredisk --only-use=${sys_disk}" >"${output_file}"

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
    screen -dmS tsc_cobbler_container systemd-nspawn --register=no --machine=tsc_cobbler -qbD "${rootfs}" \
        --bind-ro="${BASE_DIR}"/etc/container/var/lib/cobbler/distro_signatures.json.tsc:/var/lib/cobbler/distro_signatures.json \
        --bind-ro="${BASE_DIR}"/etc/container/etc/cobbler/dhcp.template:/etc/cobbler/dhcp.template \
        --bind-ro="${BASE_DIR}"/etc/container/etc/cobbler/settings.d/tsc.settings:/etc/cobbler/settings.d/tsc.settings \
        --bind-ro="${BASE_DIR}"/globe.common.conf:/tmp/globe.common.conf \
        --bind-ro="${BASE_DIR}"/tmp/init.sh:/tmp/init.sh \
        --bind-ro="${BASE_DIR}"/"${EL7__x86_64[0]}-${EL7__x86_64[1]}":"/var/www/html/${EL7__x86_64[0]}-${EL7__x86_64[1]}" \
        --bind-ro="${BASE_DIR}"/"${EL7__aarch64[0]}-${EL7__aarch64[1]}":"/var/www/html/${EL7__aarch64[0]}-${EL7__aarch64[1]}" \
        --bind-ro="${BASE_DIR}"/"${FHOS__x86_64[0]}-${FHOS__x86_64[1]}":"/var/www/html/${FHOS__x86_64[0]}-${FHOS__x86_64[1]}" \
        --bind-ro="${BASE_DIR}"/"${FHOS__aarch64[0]}-${FHOS__aarch64[1]}":"/var/www/html/${FHOS__aarch64[0]}-${FHOS__aarch64[1]}" # \
    # &>>"${log_file}"

    cobbler_boot_flag=0
    for dot_cnt in {1..120}; do
        running_ports=()
        for port in "${ports[@]}"; do
            if [[ $(ss -lnoptu src ":${port}" | wc -l) -gt 1 ]]; then
                # lsof -nP -iTCP:80 -sTCP:LISTEN
                running_ports+=("${port}")
            fi
        done
        if [[ ${#running_ports[@]} -ne ${#ports[@]} ]]; then
            sleep 5
            echo -en "\033[2K\r$(printf '.%.0s' $(seq 1 "${dot_cnt}"))"
        else
            cobbler_boot_flag=1
            break
        fi
    done
    if [[ ${cobbler_boot_flag} -eq 0 ]]; then
        echo -en "\033[2K\r"
        LOGERROR "启动失败, 请参考 readme.md 排查"
        exit 41
    else
        echo -en "\033[2K\r"
        LOGSUCCESS "${FUNCNAME[0]}"
    fi
}

LOGINFO start
if pgrep -f "systemd-nspawn --register=no --machine=tsc_cobbler" &>/dev/null; then
    LOGWARNING 已启动安装服务, 将在 10 秒内结束已启动的安装服务, 如需保留现有服务请在 10 秒内按 ctrl + c
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
