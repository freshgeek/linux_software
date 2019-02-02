
#文件读取服务器写法 , 少量的话也可以使用直接数组赋值的方式
arr=($(awk '{print $1}' slave))
#arr=(1 2 3)
for i in ${arr[@]};do
 echo $i
 scp -r /app/hadoop-2.9.2 root@$i:/app/
done



