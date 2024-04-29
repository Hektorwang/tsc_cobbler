#!/bin/bash
set +o posix
for serv in $(
    systemctl list-unit-files --state=enabled --type=service -l --no-pager --no-legend |
        awk '{print $1}'
); do
    systemctl disable "${serv}" 2>/dev/null
done

for serv in \
    abrtd.service \
    auditd.service \
    crond.service \
    getty@tty1.service \
    ipmi.service \
    irqbalance.service \
    microcode.service \
    NetworkManager.service \
    rsyslog.service \
    sshd.service \
    sysstat.service \
    tuned.service; do
    systemctl enable "${serv}" 2>/dev/null
done
rpm -q sssd && systemctl enable sssd

systemctl set-default multi-user.target

sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

