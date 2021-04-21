#!/usr/bin/env bash

declare -a geom=("1.3" "1.4" "1.5" "1.6" "1.7" "1.8" "1.9" "2.0" "2.1" "2.2")

for i in "${geom[@]}"
do
	echo ${i}
	cd ${i}
	cat 3.csv >> ../3.csv
	cd ../
done

