
#VMware 在基本的一台机器的基础上 克隆新的机器
# 重新修改思路 , 直接开启新克隆机器 运行本地脚本即可 

#本地脚本需要编辑的文件有

#主机名称  一般只有一个 但是我的好像两个都有 有点奇怪 所以都改了
#/etc/hostname
#/etc/sysconfig/network

#域名映射文件
#/etc/hosts


#IP地址分配
#vi /etc/sysconfig/network-scripts/ifcfg-ens33


#最后重启生效 重启手动完成 
#reboot


#echo 输入目标机器IP 修改主机名 修改主机IP
#echo $1 $2 $3 
edit_local () {
        g_source_hostname=`cat /etc/hostname`;
	echo $2>/etc/hostname;
	cat /etc/hostname;
	sed -i "s/$g_source_hostname/$2/" /etc/sysconfig/network 
	cat /etc/sysconfig/network
	echo "$3 $2">>/etc/hosts;
	cat /etc/hosts
	sed -i "s/$1/$3/" /etc/sysconfig/network-scripts/ifcfg-ens33
	cat /etc/sysconfig/network-scripts/ifcfg-ens33
}

if [ $# -eq 3 ];
then 
	edit_local $1 $2 $3 ;
fi;

