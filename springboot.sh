#!/bin/bash
# 应用全路径
appName="/www/wwwroot/java/reward-service/reward-service.jar"
# 应用启动端口
appPort=8366
# 应用debug 远程端口，测试环境配置、线上未配置
debugPort=$((1+$appPort))
# 应用IP地址
appIp="x.x.x.x"
# sky插件全路径
sky="/www/wwwroot/java/skywalking-agent/skywalking-agent.jar"
# 配置文件全路径
configFile="/www/wwwroot/java/reward-service/application.yml"
# 控制台输出文件
logName="console-$appPort"
# debug 测试环境1g
jvm="/usr/local/btjdk/jdk8/bin/java -server -Dsun.misc.URLClassPath.disableJarChecking=true -Xms1g -Xmx1G  -XX:MaxMetaspaceSize=512m -XX:MetaspaceSize=512m -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=./gc-log-heapdump-$appPort.hprof -XX:+PrintGC -Xloggc:./gc-log-$appPort.log -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintGCTimeStamps  -Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/urandom   -Xdebug -Xrunjdwp:transport=dt_socket,address=$debugPort,server=y,suspend=n  -Dserver.tomcat.uri-encoding=UTF-8 "
# 线上环境4g 关闭debug 
# jvm="/usr/bin/java -server -Dsun.misc.URLClassPath.disableJarChecking=true -Xms4g -Xmx4G -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=./gc-log-heapdump-$appPort.hprof -XX:+PrintGC -Xloggc:./gc-log-$appPort.log -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintGCTimeStamps   -Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/urandom -XX:MaxMetaspaceSize=512m -XX:MetaspaceSize=512m  -Dserver.tomcat.uri-encoding=UTF-8 "


if [ -z $appName ]
then
    echo "appName 不存在，请检查路径是否正确 : $appName"
    exit 1
fi
 
killForceFlag=$2
 
function getPid(){
  pid=`ps -ef |grep java | grep -v grep | grep -v old|grep $appName | grep $appPort |awk '{print $2}'`
  echo "$pid"
}

function start()
{
    count=`getPid`
    if [ $count ];then
        echo "$appName 在运行中，pid = $count "
    else
        echo " $appName 启动中..."
        nohup $jvm -Dspring.config.location=$configFile  -javaagent:$sky  -Dskywalking.agent.instance_name=$appPort@$appIp  -jar $appName  --server.port=$appPort  > $logName 2>&1 &
        echo "========输出控制台日志,请输入 tail -f $logName，随时可以Ctrl+C终止======"
    fi
}
 
function stop()
{
  echo "停止应用 $appName pid = `getPid`"
  appId=`getPid`
  kill $appId
  while :
        do
            appId=`getPid`
            if [ -z $appId ];then
                echo "Stop success"
                break
            else
                echo -e "."
                sleep 1
            fi
    done
}
function status()
{
    appId=`getPid`
    if [ -z $appId ] 
    then
        echo -e "${appId} [$appName] 没在运行中" 
    else
        echo -e "[$appId] [$appName] 运行中" 
    fi
}
 
function restart()
{
    stop
    start
} 
 
function usage()
{
    echo "Usage: $0 {start|stop|restart|status|stop -f}"
    echo "Example: $0 start"
    exit 1
}
 
case $1 in
    start)
    start;;
 
    stop)
    stop;;
    
    restart)
    restart;;
    
    status)
    status;;
    
    *)
    usage;;
esac
