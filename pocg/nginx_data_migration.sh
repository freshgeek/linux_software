echo "请先确认开启了免密"

sleep 10s

re_host=$1


#配置文件
scp -r root@$re_host:/etc/nginx/my.conf /etc/nginx/

#host
scp -r root@$re_host:/etc/hosts /etc/

#nginx 主配置
scp -r root@$re_host:/etc/nginx/nginx.conf /etc/nginx/

#nginx 引用
scp -r root@$re_host:/etc/nginx/my.config /etc/nginx/

#ss 备份
scp -r root@$re_host:/root/back /root/

#ss 脚本
scp -r root@$re_host:/root/shell /root/


systemctl stop firewalld.service #停止firewall
	
systemctl disable firewalld.service #禁止firewall开机启动
