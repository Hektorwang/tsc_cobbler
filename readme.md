# readme

## 工具介绍

在一台主机上部署 `cobbler` 服务, 提供该主机作为**无人值守操作系统安装服务主机**能力.

- 服务主机要求
  - CPU 架构: `x86_64`
  - 操作系统为 `EL7/8/9`
  - 已安装组件: `initscripts`, `net-tools`, `screen`, `systemd`(EL7)/`systemd-container`(EL9)
- 客户端支持
  - 部署 `CentOS-7` 和 `FitStarrySkyOS` 操作系统
  - 支持 `x86_64` 和 `aarch64` 架构
  - 支持 `legacy BIOS` 和 `UEFI` 引导模式.

## 使用方法

### 解压

将 tsc_cobbler-EL789-x86_64-版本-日期.tar.gz 解压到安装主机的 `/home/` 目录下.

### 配置

编辑工具主目录下 `globe.comm.conf`.

- 远程安装操作系统需要在服务主机启动一个虚拟机网卡, 用来指定一个和本地业务网络不同的网段作为操作系统安装网段以避免冲突
- 并指定新装操作系统的 root 用户密码
- 指定待安装操作系统服务器的系统盘块设备文件名( sda, hda, /dev/mapper/mp1... )

```ini
# [必须配置] 需要启动虚拟 IP 的网卡, 一般在内网通信网卡名后加 ":1". cobbler_nic="eth0:1"
cobbler_nic="eth0:1"
# [必须配置] 用来进行作为操作系统远程安装服务的虚拟网卡 IP. cobbler_ip="172.16.233.28"
cobbler_ip="172.16.233.28"
# [必须配置] 用来进行作为操作系统远程安装服务的虚拟网卡掩码. cobbler_netmask="255.255.255.192"
cobbler_netmask="255.255.255.192"
# [必须配置] 用来分配给待安装操作系统客户机的 IP 起止, 用空格 " " 分隔. dhcp_range="172.16.233.29 172.16.233.35"
dhcp_range="172.16.233.29 172.16.233.35"
# [必须配置] 新安装操作系统的 root 密码. passwd="Fhaw0025."
root_passwd="Fhaw0025."
# [必须配置] 新装系统服务器的系统盘块设备名 sys_disk=sda
sys_disk=vda
```

### 挂载操作系统镜像

- 根据所需安装的操作系统, 将对应的 iso 文件挂载到工具主目录下对应的 `EL7-x86_64`, `EL7-aarch64`, `FHOS-x86_64`, `FHOS-aarch64` 的目录中.
- 本工具理论支持所有版本和 CPU 架构的 `CentOS-7`, `FitStarrySkyOS-22.06.1` 的操作系统 ISO 镜像文件.
- 本工具在如下 ISO 文件下进行测试:

| md5                              | 文件名                                                 |
| -------------------------------- | ------------------------------------------------------ |
| b1157154969df920bda486fa84adcdb0 | CentOS-7-aarch64-Everything-1810.iso                   |
| d23eab94eaa22e3bd34ac13caf923801 | CentOS-7-x86_64-Everything-1708.iso                    |
| 268c1b127b57f6a7307abac9a9ffa369 | fitstarryskyos-22.06.1-aarch64-everything-20240126.iso |
| ef9495c99d0a94be11a5cc56dadc182a | fitstarryskyos-22.06.1-x86_64-everything-20240126.iso  |

```bash
mount -t iso9660 -o loop CentOS-7-x86_64-Everything-1708.iso EL7-x86_64
mount -t iso9660 -o loop CentOS-7-aarch64-Everything-1810.iso EL7-aarch64
mount -t iso9660 -o loop fitstarryskyos-22.06.1-x86_64-everything-20240126.iso FHOS-x86_64
mount -t iso9660 -o loop fitstarryskyos-22.06.1-aarch64-everything-20240126.iso FHOS-aarch64
```
