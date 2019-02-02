
arr=($(awk '{print $1}' slave))
#arr=(1 2 3)
for i in ${arr[@]};do
 #echo $i
 ssh $i "source /etc/profile;systemctl stop firewalld.service;systemctl disable firewalld.service;"
done



