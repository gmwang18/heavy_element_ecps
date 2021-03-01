#!/usr/bin/env bash

rm 3.csv

for ((i=1; i<=9; i++))
do
	echo ${i}
	cd ${i}
	cat 3.csv >> ../3.csv
	cd ../
done

