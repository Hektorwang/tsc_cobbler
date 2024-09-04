ls
cd /tmp
ls
cat /etc/cobbler/settings.d/tsc.settings 
./init.sh 
ls
systemctl status cobblerd
systemctl status httpd
systemctl status dhcpd
cd /etc/dhcp
ls
cat dhcpd.conf 
cat dhcpd.conf |more
/tmp/init.sh 2>&1 | tee -a ~/aa.log
ls
cd
ls
vim -R aa.log 
more aa.log 
cat /tmp/init.sh 
    systemctl restart cobblerd
systemctl status cobblerd
