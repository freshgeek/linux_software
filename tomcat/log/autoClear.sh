#!/bin/bash

#PATH=$PATH:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:/root/bin
. /etc/profile
#export PATH=/bin/bash:$PATH
##########################################################################
#  脚本说明: v2.0
#  作者:chen.chao
#   用作自动清理脚本 , 与手动清理脚本不同的是不能全部移除
#   所以需要添加时间判断,文件类型判断,操作日志写入
#   需要删除的日志文件逻辑依旧是
#   将复制到tmp文件夹下,由定时任务统一删除
#   1.catalina.yyyy-mm-dd.log
#   2.host-manager.yyyy-mm-dd.log
#   3.localhost.yyyy-mm-dd.log
#   4.localhost_access_log.yyyy-mm-dd.txt
#   5.manager.yyyy-mm-dd.log
#   清空catalina.out文件内容
#######################################################################################################
#   自动脚本使用说明:
#   1.配合定时任务使用 
#   2.定时任务周期应该等于日期区间 比如定时任务7天运行一次本脚本 本脚本一次删除七天之前的日志
#   3.运行前设置哪些日志保留哪些删除   在删除参数中设置 true为删除
#   
#
#######################################################################################################
#tomccats实例路径(默认/tomcat/tomcat7)
tomcats_dir="/tomcat/tomcat7"
#获取当前目录路径
curr_dir=`pwd`
#echo $curr_dir
#文件移除目标路径
target_dir="/tmp/tomcat_log_remove/"
#当前目录下tomcat 实例名的特征字符串 (默认tomcat7-Sale)
proper_value="tomcat7-Sale"
#打印日志文件名
log_name=$curr_dir"/log_clear.txt"

#####日期区间##############
date_interval=3
#####删除参数###############
######删除则设置为true
#   1.catalina.yyyy-mm-dd.log
catalina=true 
#   2.host-manager.yyyy-mm-dd.log
host_manager=true      
#   3.localhost.yyyy-mm-dd.log
localhost=true
#   4.localhost_access_log.yyyy-mm-dd.txt
localhost_access_log=true
#   5.manager.yyyy-mm-dd.log
manager=true
#   清空catalina.out文件内容
catalina_out=true




#######函数:

#######   根据全局参数判断是否删除文件
#######   输入参数 文件名
#######   输出参数 0不删除  1删除 

checkFileDel(){
	if [ -n $1 ]
	then 
	#不为空 判断参数	
	case "$1" in
		"catalina")
			if $catalina ;then
				return 1
			else 
				return 0
			fi
			;;
		"host-manager")
			if $host_manager ; then
				return 1
			else
				return 0
			fi
			;;
		"localhost")
			if $localhost ; then
				return 1
			else
				return 0
			fi
			;;
		"localhost_access_log")
			if $localhost_access_log ; then
				return 1
			else
				return 0
			fi
			;;
		"manager")
			if $manager ; then
				return 1
			else
				return 0
			fi
			;;
	esac
	else
	#为空不做处理
	#输出日志
		echo `date "+%Y-%m-%d %H:%M:%S"`"参数文件名前缀为空" >> $log_name
	return 0
	fi

}


#######   清除单个实例中的日志文件 默认 清除所有日志和清空.out文件
#######   
#######   必须传入参数 : tomcat 实例路径
singleClear(){
    if [ "$1" ]
    then
        curr=$1/logs
        #echo `date "+%Y-%m-%d %H:%M:%S"`"清除$curr日志" >> $log_name
        ###日志目录下的所有文件
        logs_files=`ls $curr`
        #遍历所有文件
        for ele in $logs_files
        do
            #echo $ele
            #判断catalina.out
            if [ $ele == "catalina.out" ]
            then
                if $catalina_out ; then
		echo `date "+%Y-%m-%d %H:%M:%S"`"$curr/$ele 清空内容" >> $log_name ;
                  >$curr/$ele;
	#	else
	#	echo `date "+%Y-%m-%d %H:%M:%S"`"$curr/$ele 不清空内容" >> $log_name
		fi
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
                ###文件前缀 用于判断删除哪种类型文件
                file_prefix=${temp_str[0]}
                ### 日期 附加段 用于判断日期
                file_date=${temp_str[1]}
                ### 后缀 判断是什么类型的文件
                file_suffix=${temp_str[2]}

                #日期判断 
		#1.获取当前日期秒数
		curr_ss=`date -d "$((-$date_interval)) day" +%Y-%m-%d`
		#2.减去日期区间秒数
		comp_date_ss=`date -d "$curr_ss" +%s`
		#3.获取文件日期秒数
		file_date_ss=`date -d "$file_date" +%s`
		#4.比较大小
		if [ "$file_date_ss" -le "$comp_date_ss" ] ;then
			#区间之外的文件删除
			#移除文件判断 
			checkFileDel "$file_prefix"
			if [ $? = "1" ] ; then 
		                #移动到指定文件夹
				v1=$1
				#移动文件名添加前缀方便查错,否则文件名相同会覆盖
				mv $curr/$ele $target_dir${v1##*/}-$ele
                		echo `date "+%Y-%m-%d %H:%M:%S "`"移动文件$curr/$ele ==> $target_dir${v1##*/}-$ele " >> $log_name
			fi
		#else
		#echo `date "+%Y-%m-%d %H:%M:%S "`"$date_interval内不删除$curr/$ele" >> $log_name
		fi
	fi
	done
    else
        echo `date "+%Y-%m-%d %H:%M:%S "`"失败,未带tomcat实例路径参数,或者参数错误" >> $log_name
    fi

}



#检索目录下tomcat实例名
#生产实例中 默认检索实例名前缀为tomcat7-Sale
echo "开始执行脚本,检索所有tomcat实例中前缀为$proper_value的文件夹" >> $log_name
#判断目标文件夹是否存在
if [ ! -d $target_dir ] ;then
	mkdir -p $target_dir
	echo "临时移除目标文件夹不存在,重新生成" >> $log_name
fi
#####遍历目录下实例符合特征tomcat实例
for file in $curr_dir/*
do
    if  [[ -d $file ]] && [[ $file =~ $proper_value ]]
    then
        instances=(${instances[*]} $file)
    fi
done
for ele in ${instances[@]}
do
	#循环遍历所有匹配实例
	singleClear $ele

done

echo `date "+%Y-%m-%d %H:%M:%S "`"脚本执行完成" >> $log_name





