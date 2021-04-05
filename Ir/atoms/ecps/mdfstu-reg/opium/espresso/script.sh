#! /bin/bash

ref1=`awk 'NR==10{print $1}' dat`
awk -v ref1=$ref1 'NR>0{printf"%.8f\n", 13.605662285137*(ref1-$1)}' dat >  errors.dat
cat errors.dat
for i in 100 200 300 400 500 600 700 800 900 3000
do 
awk -v ref1=$i 'NR>0{printf"error at cut off %u is %.8f eV \n", ref1, $1}' errors.dat > trial
done

