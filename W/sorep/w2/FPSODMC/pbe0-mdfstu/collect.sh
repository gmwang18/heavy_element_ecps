#!/usr/bin/env bash


declare -a geom=("1.7" "1.8" "1.9" "2.0" "2.1" "2.2")

echo "energy   error   state" > raw_opt.dat
for i in "${geom[@]}"
do
        echo ${i}
        en=`gosling  ${i}/W2.dmc.log | grep 'total_energy0' | tail -n 1 | awk '{print $2}'`
        err=`gosling ${i}/W2.dmc.log | grep 'total_energy0' | tail -n 1 | awk '{print $4}'`
        echo ${en} ${err} ${i} >> raw_opt.dat
done

cat raw_opt.dat

