
#2.关闭防火墙
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动

#开机自启
cat "systemctl start crond.service" >> /etc/rc.d/rc.local
#设置时区
timedatectl set-timezone Asia/Shanghai
#自动同步




#4.配置检测crond
wget --no-check-certificate -O /opt/shadowsocks-crond.sh https://raw.githubusercontent.com/freshgeek/linux_software/master/pocg/shadowsocks-crond.sh
chmod 755 /opt/shadowsocks-crond.sh
(crontab -l ; echo "* * * * * /opt/shadowsocks-crond.sh") | crontab -

#3.下载ss
wget --no-check-certificate -O shadowsocks.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh
chmod +x shadowsocks.sh
./shadowsocks.sh 2>&1 | tee shadowsocks.log



#1.开启bbr
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh

