#!/bin/bash

##########################################################################
#  脚本说明: v1.0
#  作者:chen.chao
#   一键清除本目录下的所有tomcat实例下几种日志文件
#   将复制到tmp文件夹下,由定时任务统一删除
#   1.catalina.yyyy-mm-dd.log
#   2.host-manager.yyyy-mm-dd.log
#   3.localhost.yyyy-mm-dd.log
#   4.localhost_access_log.yyyy-mm-dd.txt
#   5.manager.yyyy-mm-dd.log
#   清空catalina.out文件内容
##########################################################################
#
#
#
#
##########################################################################
#获取当前目录路径
curr_dir=`pwd`
#echo $curr_dir
#文件移除目标路径
target_dir="/tmp/tomcat_log_remove/"

#######函数:
#######   清除单个实例中的日志文件 默认 清除所有日志和清空.out文件
#######   必须传入参数 : tomcat 实例路径
singleClear(){
    #echo "清除单个 tomcat 日志"
    if [ "$1" ]
    then
        curr=$1/logs
        echo 清除$curr日志
        ###日志目录下的所有文件
        logs_files=`ls $curr`
        #遍历所有文件
        for ele in $logs_files
        do
            #echo $ele
            #判断catalina.out
            if [ $ele == "catalina.out" ]
            then
                echo "$curr/$ele 清空内容"
                >$curr/$ele

            else
                #判断时间先分割文件名
                #存储旧的分隔符
                OLD_IFS="$IFS"
                #设置分隔符
                IFS="."
                #自动分隔
                temp_str=($ele)
                #恢复原来的分隔符
                IFS="$OLD_IFS"
                #echo  ${temp_strs[0]}"    "${temp_strs[1]}"   "${temp_strs[2]}
                ###文件前缀 用于判断删除哪种类型文件
                file_prefix=${temp_str[0]}
                ### 日期 附加段 用于判断日期
                file_date=${temp_str[1]}
                ### 后缀 判断是什么类型的文件
                file_suffix=${temp_str[2]}
                #移除判断  默认移除全部 本版本暂不判断

                #日期判断 默认移除全部  本版本暂不判断

                #判断目标文件夹是否存在
                if [ ! -d $target_dir ]
                then
                    mkdir -p $target_dir
                fi
                #移动到指定文件夹
                mv $curr/$ele $target_dir

            fi
        done
    else
        echo 失败,未带参数
    fi

}






#当前目录下tomcat 实例名的特征字符串 (默认tomcat7-Sale)
proper_value="tomcat7-Sale"

#检索目录下tomcat实例名
#生产实例中 检索实例名前缀为tomcat7-Sale
echo "检索生产tomcat实例中前缀为$proper_value的文件夹"

for file in $curr_dir/*
do

    if  [[ -d $file ]] && [[ $file =~ $proper_value ]]
    then
        instances=(${instances[*]} $file)
    fi
done
echo "将清除下列实例中的日志文件"
for ele in ${instances[@]}
do
    echo $ele
    #echo invoke fun
    singleClear $ele
done

#分别进入日志logs文件夹

#打印文件前缀 以点区分

#
#


































