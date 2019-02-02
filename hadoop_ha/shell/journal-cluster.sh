

arr=(zookeeper001 zookeeper002 zookeeper003)

for i in ${arr[@]};do
 echo $i
 ssh $i "source /etc/profile;hadoop-daemon.sh start journalnode";
done



