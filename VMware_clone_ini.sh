
#VMware 在基本的一台机器的基础上 克隆新的机器


#需要前提是 机器已经配置好网络 , 由于是 克隆机 , 所以 需要将原机器停下 , 克隆后                                                                                                              相当于原机器 IP地址也是相同
clear;

#同时打开免密登陆
echo 运行克隆机器初始化脚本
echo 运行前请检查是否安装ssh,[ yum install -y openssh-clients ]
echo 是否生成公钥 , [ ssh-keygen -t rsa ]

#输入克隆机IP
echo 输入目标机器IP
read v_source_host;
echo $v_source_host;


#在基本机器上重新克隆后,需要对新机器重新分配IP ,为方便同时给新机器取别名
echo 输入修改机器名
read v_tar_hostname;

echo $v_tar_hostname;
#echo 输入修改机器IP地址
#read v_tar_host;
#echo $v_tar_host;

#打开免密登陆
echo 开启免密登陆
ssh-copy-id -i /root/.ssh/id_rsa.pub $v_source_host 1>/dev/null 2>/dev/null


#直接执行源机器上的sh脚本 操作本机 配置文件 

#需要编辑的文件有
#名称  一般只有一个 但是我的好像两个都有 有点奇怪 所以都改了
#/etc/hostname
#/etc/sysconfig/network

#域名映射文件
#/etc/hosts


#IP地址分配
#vi /etc/sysconfig/network-scripts/ifcfg-ens33


#最后重启生效
#reboot

