#!/usr/bin/env bash

rm 3.csv

for ((i=1; i<=16; i++))
do
	echo ${i}
	cd ${i}
	tail tz.table1.txt >> ../3.csv
	cd ../
done

sed -i "s/ //g" 3.csv
sed -i "/0\.00000/d" 3.csv
sed -i "/^$/d" 3.csv
#sed -i "/Z,SCF,CCSD*$/d" 3.csv

