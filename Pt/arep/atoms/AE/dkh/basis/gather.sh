#!/usr/bin/env bash
rm 3.csv

for ((i=1; i<=15; i++))
do
	echo ${i}
        cd ${i}
        tail 3.table1.csv >> ../3.csv
        cd ../
done


