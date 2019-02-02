


if [ $# -eq 0 ];then
 echo "start 启动集群"
 echo "stop 关闭集群"
 echo "status 查看集群状态"
else
 zkServer.sh $1
 ssh zookeeper002 "source /etc/profile;cd /app/zookeeper-3.4.12/bin;./zkServer.sh $1"
 ssh zookeeper003 "source /etc/profile;cd /app/zookeeper-3.4.12/bin;./zkServer.sh $1"
fi;


