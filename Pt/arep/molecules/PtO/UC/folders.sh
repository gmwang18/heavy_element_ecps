#!/usr/bin/env bash

bondlength=(1.5 1.6 1.7 1.8 1.9 2.0)

for i in "${bondlength[@]}"
do
        echo $i
        cp -r template $i
        cd $i
        sed -i "s/bondlength/$i/g" 3.com
        sed -i "s/bondlength/$i/g" job
        sbatch job
        #cat 3.csv >> ../3.csv
        cd ../
done


