# readme

## 工具介绍

在一台主机上部署 `cobbler` 服务, 提供该主机作为**无人值守操作系统安装服务主机**能力.

- 服务主机要求
  - CPU 架构: `x86_64`
  - 操作系统为 `EL7/9`， `FHOS`
  - 已安装组件: `initscripts`, `net-tools`, `screen`, `systemd`(EL7)/`systemd-container`(EL9/FHOS)
- 客户端支持
  - 部署 `CentOS-7` 和 `FitStarrySkyOS` 操作系统
  - 支持 `x86_64` 和 `aarch64` 架构
  - 支持 `legacy BIOS` 和 `UEFI` 引导模式.

## 使用方法

### 解压

将 `tsc_cobbler-EL789-x86_64-版本-日期.tar.gz` 解压到安装主机的 `/home/` 目录下.

### 配置

编辑工具主目录下 `globe.comm.conf`.

- 远程安装操作系统需要在服务主机启动一个虚拟机网卡, 用来指定一个和本地业务网络不同的网段作为操作系统安装网段以避免冲突
- 并指定新装操作系统的 root 用户密码
- 指定待安装操作系统服务器的系统盘块设备文件名( sda, sdb, hda, mp1... )

```ini
# [必须配置] 需要启动虚拟 IP 的网卡, 一般在提供远程文件服务的通信网卡名后加 ":1". cobbler_nic="eth0:1"
cobbler_nic="eth0:1"
# [必须配置] 用来进行作为操作系统远程安装服务的虚拟网卡 IP. cobbler_ip="172.16.233.28"
cobbler_ip="172.16.233.28"
# [必须配置] 用来进行作为操作系统远程安装服务的虚拟网卡掩码. cobbler_netmask="255.255.255.192"
cobbler_netmask="255.255.255.192"
# [必须配置] 用来分配给待安装操作系统客户机的 IP 起止, 用空格 " " 分隔. dhcp_range="172.16.233.29 172.16.233.35"
dhcp_range="172.16.233.29 172.16.233.35"
# [必须配置] 新安装操作系统的 root 密码. passwd="Fhaw0025."
root_passwd="Fhaw0025."
# [必须配置] 新装系统服务器的系统盘块设备文件名 sys_disk=sda
# !!!若置为空 sys_disk= ,则会安装到系统识别到的第一块硬盘上, 该硬盘有可能是数据盘导致数据被覆盖!!!
sys_disk=vda
```

### 挂载操作系统镜像

- 根据所需安装的操作系统, 将对应的 iso 文件挂载到工具主目录下对应的 `EL7-x86_64`, `EL7-aarch64`, `FHOS-x86_64`, `FHOS-aarch64` 的目录中.
- 本工具理论支持所有版本和 CPU 架构的 `CentOS-7`, `FitStarrySkyOS-22.06.1` 的操作系统 ISO 镜像文件.
- 本工具在如下 ISO 文件下进行测试:

| md5                              | 文件名                                                 | 挂载点       |
| -------------------------------- | ------------------------------------------------------ | ------------ |
| b1157154969df920bda486fa84adcdb0 | CentOS-7-aarch64-Everything-1810.iso                   | EL7-aarch64  |
| d23eab94eaa22e3bd34ac13caf923801 | CentOS-7-x86_64-Everything-1708.iso                    | EL7-x86_64   |
| 268c1b127b57f6a7307abac9a9ffa369 | fitstarryskyos-22.06.1-aarch64-everything-20240126.iso | FHOS-aarch64 |
| ef9495c99d0a94be11a5cc56dadc182a | fitstarryskyos-22.06.1-x86_64-everything-20240126.iso  | FHOS-x86_64  |

```bash
mount -t iso9660 -o loop CentOS-7-x86_64-Everything-1708.iso EL7-x86_64
mount -t iso9660 -o loop CentOS-7-aarch64-Everything-1810.iso EL7-aarch64
mount -t iso9660 -o loop fitstarryskyos-22.06.1-x86_64-everything-20240126.iso FHOS-x86_64
mount -t iso9660 -o loop fitstarryskyos-22.06.1-aarch64-everything-20240126.iso FHOS-aarch64
```

### 运行工具

```bash
# 必须使用管理权限用户
sudo ./run.sh
```

```text
[2024-04-30 01:04:29]   INFO    run.sh  start
[2024-04-30 01:04:29]   WARNING run.sh  已启动安装服务, 将在 10 秒内结束已启动的安装服务, 如需保留现有服务请在 10 秒内按 ctrl + c
[2024-04-30 01:04:39]   INFO    run.sh  check_env
[2024-04-30 01:04:39]   SUCCESS run.sh  IP在网络内: 192.168.123.2 192.168.123.1 255.255.255.192
[2024-04-30 01:04:39]   SUCCESS run.sh  IP在网络内: 192.168.123.10 192.168.123.1 255.255.255.192
[2024-04-30 01:04:39]   SUCCESS run.sh  已挂载 EL7-x86_64 ISO 到 /home/tsc_cobbler/EL7-x86_64
[2024-04-30 01:04:39]   WARNING run.sh  未挂载 EL7-aarch64 ISO 到 /home/tsc_cobbler/EL7-aarch64, 将无法提供该操作系统远程安装服务
[2024-04-30 01:04:39]   WARNING run.sh  未挂载 FHOS-x86_64 ISO 到 /home/tsc_cobbler/FHOS-x86_64, 将无法提供该操作系统远程安装服务
[2024-04-30 01:04:39]   WARNING run.sh  未挂载 FHOS-aarch64 ISO 到 /home/tsc_cobbler/FHOS-aarch64, 将无法提供该操作系统远程安装服务
[2024-04-30 01:04:39]   SUCCESS run.sh  check_env
[2024-04-30 01:04:39]   INFO    run.sh  config_nic
[2024-04-30 01:04:39]   SUCCESS run.sh  config_nic
[2024-04-30 01:04:39]   INFO    run.sh  config_container
[2024-04-30 01:04:39]   SUCCESS run.sh  config_container
[2024-04-30 01:04:39]   INFO    run.sh  start_container
[2024-04-30 01:04:39]   INFO    run.sh  开启 cobbler 服务, 可能需要数分钟, 请稍候...
[2024-04-30 01:06:20]   SUCCESS run.sh  start_container
```

## 故障排查

若执行 `./run.sh` 10 分钟后 cobbler 容器仍未拉起所有服务, 则需检查容器内服务启动状态.

```bash
screen -r tsc_cobbler_containe
# 登录容器, 用户: root, 密码: Fiberhome@2024
# 检查服务状态
systemctl status httpd cobblerd dhcpd tftp.socket
# 检查各配置中 IP 是否正确
cat /var/lib/cobbler/collections/distros/*.json
cat /etc/dhcpd/dhcpd.conf
cat /etc/cobbler/settings.d/tsc.settings
# 若 IP 正确, 尝试重新启动服务
/tmp/init.sh
# 检查服务状态
systemctl status httpd cobblerd dhcpd tftp.socket
# 检查 cobbler 服务配置是否同步, 其中配置 IP 是否正确
cobbler distro report
```
