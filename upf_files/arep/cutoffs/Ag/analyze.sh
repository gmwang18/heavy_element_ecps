#!/bin/bash
nelectron=19
pwd=`pwd`
#echo $pwd
cd 250-610/runs
for d in */ ; do
	echo "$d" >> $pwd/temp1.dat
	cd $d
	grep '!    total energy' *.out >> $pwd/temp2.dat

	cd ../
done

cd $pwd/1000/runs
grep '!    total energy' */*.out >> $pwd/compare.dat

cd $pwd
paste temp1.dat temp2.dat > data.dat

rm temp1.dat temp2.dat

awk  '{print $1}' data.dat > xs.dat
awk  '{print $6}' data.dat > ys.dat
paste xs.dat ys.dat > energy.dat
rm xs.dat ys.dat
sed -i 's/\///g' energy.dat 
sed -i 's/scf_//g' energy.dat

awk '{print $1}' energy.dat > temp1.dat
ref=`awk '{print $5}' compare.dat` 
#echo $ref
awk -v ref=$ref -v nelec=$nelectron '{printf("%.8f\n", ($2-ref)*13.6056980659/nelec)}' energy.dat  > temp2.dat

paste temp1.dat temp2.dat > processed.dat

rm temp1.dat temp2.dat data.dat compare.dat

awk '$2 < 0.001' processed.dat > final.dat

head -n 1 final.dat > output.dat
rm final.dat

awk '{print $1" Ry      "$2" eV/e"}' output.dat > result.out
rm output.dat
