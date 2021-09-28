#!/usr/bin/env bash


declare -a geom=("2.2" "2.3" "2.4" "2.5" "2.6" "2.7")

echo "energy   error   state" > raw_opt.dat
for i in "${geom[@]}"
do
        echo ${i}
        en=`gosling  ${i}/Ag2.dmc.log | grep 'total_energy0' | tail -n 1 | awk '{print $2}'`
        err=`gosling ${i}/Ag2.dmc.log | grep 'total_energy0' | tail -n 1 | awk '{print $4}'`
        echo ${en} ${err} ${i} >> raw_opt.dat
done

cat raw_opt.dat

