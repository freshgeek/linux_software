# apollo 版本
version=2.1.0

# config service db地址 
db_cs_url=jdbc:mysql://xxx.mysql.rds.aliyuncs.com:3306/apollo_config?characterEncoding=utf8
db_cs_username=apollo
db_cs_password=xxx
# 对应cs的容器外可访问路径
cs_url=http://x.x.x.xx:8060

# config service pro环境 db 地址
db_cs_pro_url=jdbc:mysql://rm-xxx.mysql.rds.aliyuncs.com:3306/apollo_config_pro?characterEncoding=utf8
# 对应cs pro 的容器外可访问路径
cs_pro_url=http://x.x.x.x:8061

# web
db_url=jdbc:mysql://rm-xxx.mysql.rds.aliyuncs.com:3306/apollo_portal?characterEncoding=utf8
db_username=apollo
db_password=xxx

function start(){
# 配置中心
docker run -p 8060:8080 \
    -e SPRING_DATASOURCE_URL=${db_cs_url} \
    -e SPRING_DATASOURCE_USERNAME=${db_cs_username} \
    -e SPRING_DATASOURCE_PASSWORD=${db_cs_password} \
    -e EUREKA_INSTANCE_HOME_PAGE_URL=${cs_url} \
    -d -v /tmp/logs:/data/logs/cs \
    --name apollo-cs \
    apolloconfig/apollo-configservice:${version}


# 管理服务
docker run -p 8090:8090 \
    -e SPRING_DATASOURCE_URL=${db_cs_url} \
    -e SPRING_DATASOURCE_USERNAME=${db_cs_username} \
    -e SPRING_DATASOURCE_PASSWORD=${db_cs_password} \
    -d -v /tmp/logs:/data/logs/cs \
    --name apollo-as \
    apolloconfig/apollo-adminservice:${version}
    


# 配置中心
docker run -p 8061:8080 \
    -e SPRING_DATASOURCE_URL=${db_cs_pro_url} \
    -e SPRING_DATASOURCE_USERNAME=${db_cs_username} \
    -e SPRING_DATASOURCE_PASSWORD=${db_cs_password} \
    -e EUREKA_INSTANCE_HOME_PAGE_URL=${cs_pro_url} \
    -d -v /tmp/logs:/data/logs/cs \
    --name apollo-cs1 \
    apolloconfig/apollo-configservice:${version}


# 管理服务
docker run -p 8091:8090 \
    -e SPRING_DATASOURCE_URL=${db_cs_pro_url} \
    -e SPRING_DATASOURCE_USERNAME=${db_cs_username} \
    -e SPRING_DATASOURCE_PASSWORD=${db_cs_password} \
    -d -v /tmp/logs:/data/logs/cs \
    --name apollo-as1 \
    apolloconfig/apollo-adminservice:${version}    

# WEB
docker run -p 8070:8070 \
    -e SPRING_DATASOURCE_URL=${db_url} \
    -e SPRING_DATASOURCE_USERNAME=${db_username} \
    -e SPRING_DATASOURCE_PASSWORD=${db_password} \
    -e APOLLO_PORTAL_ENVS=TEST,PRO \
    -e TEST_META=${cs_url} \
    -e PRO_META=${cs_pro_url} \
    -d -v /tmp/logs:/data/logs/portal --name apollo-portal \
    apolloconfig/apollo-portal:${version}

}
start
# 删除容器脚本
# docker ps |grep apollo |awk '{ print $1}' | xargs docker rm -f 
