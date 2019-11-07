#!/bin/bash

cpu_quantity = cat /proc/cpuinfo | grep processor | wc -l
memory_amount = free -m | awk '{print $2}' | awk ‘(NR == 2)’
current_memory = free -m | awk '{print $4}’ | awk ‘(NR == 2)’
let “memory_usage_percent = current_memory/memory_amount*100”
counter=0
limit_up = cat servicescalepolicy | grep max | awk -F=" " '{print $2}'
limit_down = cat servicescalepolicy | grep min | awk -F=" " '{print $2}'
current_pods = cat Deployment | grep replicas | awk -Freplicas:" " '{print $2}'
rm Deployment.template
wget https://github.com/illiagunko/msterdegree/blob/master/configuration/Deployment.template

#if counter; else ; fi
if [ "$counter" -gt 0 ]; 
  then let "new_pods = current_pods + 1"
    sed 's/{pods}/$new_pods' ./Deployment
elif [ "$counter" -lt 0 ];
  then let "new_pods = current_pods - 1"
    sed 's/{pods}/$new_pods' ./Deployment
fi

if [ "$counter" -gt 0 ]; 
    then let "new_pods = current_pods + 1"
elif [ "$counter" -lt 0 ];
  then let "new_pods = current_pods - 1"
fi

if [ "$new_pods" -lt "$limit_up" ] && [ "$new_pods" -gt "$limit_down" ]; 
    then sed 's/{pods}/$new_pods' ./Deployment
fi

kubectl create -f Deployment
