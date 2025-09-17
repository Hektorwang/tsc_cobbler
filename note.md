# note

## koan

```bash
#!/bin/bash
cobbler system add \
    --name=192.168.3.64 \
    --profile=Euler-x86_64 \
    --server=192.168.3.252 \
    --ip-address=192.168.3.64 \
    --netmask=255.255.255.0 \
    --gateway=192.168.3.1 \
    --interface=ens192 \
    --static=1

cobbler sync

koan --replace-self --server=192.168.3.252 --system=192.168.3.64

yum install -y libvirt-devel python3-devel python3-pip libvirt-devel libvirt-libs '@Development Tools'

python3 -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --upgrade pip
pip3 config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
pip3 install libvirt-python netifaces
```
