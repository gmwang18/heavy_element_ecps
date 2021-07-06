#!/usr/bin/env bash

rm 5.csv

for ((i=1; i<=10; i++))
do
	echo ${i}
	cd ${i}
	tail 5.csv >> ../5.csv
	cd ../
done

sed -i "s/ //g" 5.csv
sed -i "/0.0,0.0/d" 5.csv
sed -i "/^$/d" 5.csv
sed -i "/Z,SCF,CCSD*$/d" 5.csv
