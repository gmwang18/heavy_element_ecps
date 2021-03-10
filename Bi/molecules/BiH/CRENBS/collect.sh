#!/usr/bin/env bash

rm 3.csv

for ((i=1; i<=10; i++))
do
	echo ${i}
	cd ${i}
	tail 3.csv >> ../3.csv
	cd ../
done

