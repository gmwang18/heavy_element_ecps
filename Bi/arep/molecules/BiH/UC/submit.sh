#!/usr/bin/env bash

declare -a geom=("1.3" "1.4" "1.5" "1.6" "1.7" "1.8" "1.9" "2.0" "2.1" "2.2")

for i in "${geom[@]}"
do
	echo ${i}
	cp -a template ${i}
	cd ${i}
	sed -i "s/my_geom/${i}/g" 3.com
	sed -i "s/my_geom/${i}/g" job.slurm
	sbatch job.slurm
	cd ../
done

#for i in "${geom[@]}"
#do
#	echo ${i}
#	cd ${i}
#	cat 3.csv >> ../3.csv
#	cd ../
#done
#
