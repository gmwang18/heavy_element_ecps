#!/usr/bin/env bash

rm 3.csv


cd 1
tail 3.csv >> ../3.csv
cd ../


for i in 5
do
	echo ${i}
	cd ${i}
	tail -n 2 3.csv >> ../3.csv
	cd ../
done
