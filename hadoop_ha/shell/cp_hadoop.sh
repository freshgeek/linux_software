
arr=($(awk '{print $1}' slave))
#arr=(1 2 3)
for i in ${arr[@]};do
 echo $i
 scp -r /app/hadoop-2.9.2 root@$i:/app/
done



