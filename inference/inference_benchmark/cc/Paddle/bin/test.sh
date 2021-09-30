#!/bin/bash
default_cpu_batch_size=(1 2 4)

cpu_batch_size=${1:-${default_cpu_batch_size[@]}}
echo ${cpu_batch_size}

for batch_size in "${cpu_batch_size[*]}"
do
#    echo "$batch_size"
done

