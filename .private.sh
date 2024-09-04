#!/bin/bash
set +o posix

declare -a EL7__x86_64 EL7__aarch64 FHOS__x86_64 FHOS__aarch64
# os arch ksfile
EL7__x86_64=("EL7" "x86_64" "EL7.ks")
EL7__aarch64=("EL7" "aarch64" "EL7.ks")
FHOS__x86_64=("FHOS" "x86_64" "FHOS.ks")
FHOS__aarch64=("FHOS" "aarch64" "FHOS.ks")

declare -A requirements
# requirements=("ipcalc" "systemd-nspawn" "ifconfig" "screen")
requirements=(
    ["lsof"]="lsof"
    ["screen"]="screen"
    ["ipcalc"]="initscripts(EL7), ipcalc(FHOS)"
    ["ifconfig"]="net-tools"
    ["systemd-nspawn"]="systemd(EL7), systemd-nspawn(FHOS)"
    ["fuser"]="psmisc"
)
declare -A ports
# ports=(80 67 69)
ports=(
    ['httpd']='TCP:80'
    ['dhcpd']='UDP:67'
    ['tftp']='UDP:69'
    ['cobblerd']='TCP:25151'
)
