#!/usr/bin/env bash


declare -a geom=("2.2" "2.3" "2.4" "2.5" "2.6" "2.7" "2.8")

echo "energy   error   state" > raw_opt.dat
for i in "${geom[@]}"
do
        echo ${i}
        en=`gosling  ${i}/Au2.dmc.log | grep 'total_energy0' | tail -n 1 | awk '{print $2}'`
        err=`gosling ${i}/Au2.dmc.log | grep 'total_energy0' | tail -n 1 | awk '{print $4}'`
        echo ${en} ${err} ${i} >> raw_opt.dat
done

cat raw_opt.dat

