#!/bin/bash

HOME=`pwd`

#calc="ae"

declare -a directories=("dz" "tz" "qz")
declare -a states=("gs" "ea" "ex" "ip1" "ip2")

for i in "${directories[@]}"
do
cd $HOME/$i
rm $i.table.txt
for j in "${states[@]}"
do

	#pam --noarch --gb=5 --inp=$j.inp --mol=qz.mol
	grep '@ SCF energy' ccsd_$j''*.out | awk '{print $5}' >> scf$i.dat
	grep '@ Total CCSD(T)' ccsd_$j''*.out | awk '{print $6}' >> cc$i.dat
done
	#echo scf$i.dat 
	#echo cc$i.dat
	echo "SCF  CCSD" > $i.table.txt
	paste -d "      " scf$i.dat cc$i.dat >> $i.table.txt

rm *$i.dat
done

