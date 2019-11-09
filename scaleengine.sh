#!/bin/bash

cpu_quantity=$(cat /proc/cpuinfo | grep processor | wc -l)
#memory_amount=$(free -m | awk '{print $2}' | awk ‘(NR == 2)’)
#current_memory=$(free -m | awk '{print $4}’ | awk ‘(NR == 2)’)
current_la=$(kubectl exec -it deploy-779878df9c-k655r -- cut -c-3 /proc/loadavg)
echo $current_la > current_la.txt
current_la=$(cat current_la.txt)
rounded_la=$(printf "%.0f\n" "$current_la")
#cpu_usage_percent=$(iostat | sed -n '4p' | awk '{print $1}') 

#let “memory_usage_percent = current_memory/memory_amount*100”
#cpu_usage_percent=$(iostat | sed -n '4p' | awk '{print $1}') 

counter=0

limit_up=$(cat /root/configs/servicescalepolicy | grep max | awk -F=" " '{print $2}')
limit_down=$(cat /root/configs/servicescalepolicy | grep min | awk -F=" " '{print $2}')
current_pods=$(cat Deployment | grep replicas | awk -Freplicas:" " '{print $2}')

rm -f /root/Deployment
cp /root/configs/Deployment.template /root
mv /root/Deployment.template /root/Deployment

if [[ "$rounded_la" -gt "$cpu_quantity" ]];
    then 
let "counter=$counter+1"
elif [[ "$rounded_la"-lt"$cpu_quantity" ]];
    then 
let "counter=$counter-1"
fi   
    
if [[ "$cpu_usage_percent" -gt 90 ]];
    then 
let "counter=$counter+1"
elif [[ "$cpu_usage_percent" -lt 10 ]];
    then 
let "counter=$counter-1"
fi    

if [[ "$counter" -gt 0 ]]; 
    then 
let "new_pods=$current_pods+1"
elif [[ "$counter" -lt 0 ]];
  then 
let "new_pods=$current_pods-1"
fi

if [[ "$new_pods" -lt "$limit_up" ]] && [[ "$new_pods" -gt "$limit_down" ]]; 
    then 
sed 's/{pods}/$new_pods' ./Deployment
fi

kubectl apply -f Deployment
