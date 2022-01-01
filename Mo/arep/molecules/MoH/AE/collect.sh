#!/usr/bin/env bash

declare -a geom=("1.22" "1.32" "1.42" "1.52" "1.62" "1.72" "1.82" "1.92" "2.02" "2.12" "2.22" "2.32" "2.42" "2.52")

for i in "${geom[@]}"
do
	echo ${i}
	cd r_${i}
	cat tz.table1.txt >> ../bind.csv
	cd ../
done
