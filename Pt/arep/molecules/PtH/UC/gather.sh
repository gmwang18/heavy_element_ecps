#!/usr/bin/env bash

bondlength=(1.3 1.4 1.5 1.6 1.7 1.8)

rm 3.csv

for i in "${bondlength[@]}"
do
        echo $i
	cd $i
        cat 3.csv >> ../3.csv
	cd ../
done


