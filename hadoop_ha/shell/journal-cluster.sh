
#如果服务器多可以放在文件里取,或者名字不同则修改
arr=(zookeeper001 zookeeper002 zookeeper003)

for i in ${arr[@]};do
 echo $i
 ssh $i "source /etc/profile;hadoop-daemon.sh start journalnode";
done



