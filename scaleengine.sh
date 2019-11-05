#!/bin/bash

cpu_quantity = cat /proc/cpuinfo | grep processor | wc -l
memory_amount = free -m | awk '{print $2}' | awk ‘(NR == 2)’
current_memory = free -m | awk '{print $4}’ | awk ‘(NR == 2)’
let “memory_usage_percent = current_memory/memory_amount*100”

wget https://github.com/illiagunko/msterdegree/blob/master/Deployment
counter=0

#if counter; else ; fi
if [ "$counter" -gt 0 ]; 
  then 
    sed 's/{pods}/another test' ./Deployment
