#!/usr/bin/env bash


declare -a geom=("2.35" "2.45" "2.55" "2.65" "2.75" "2.85" "2.95")

echo "energy   error   state" > raw_opt.dat
for i in "${geom[@]}"
do
        echo ${i}
        en=`gosling-cori  ${i}/I2.dmc.log | grep 'total_energy0' | tail -n 1 | awk '{print $2}'`
        err=`gosling-cori ${i}/I2.dmc.log | grep 'total_energy0' | tail -n 1 | awk '{print $4}'`
        echo ${en} ${err} ${i} >> raw_opt.dat
done

cat raw_opt.dat

