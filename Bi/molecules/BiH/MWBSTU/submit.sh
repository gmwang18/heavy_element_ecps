#!/usr/bin/env bash

#for ((i=1; i<=9; i++))
#do
#	echo ${i}
#	cp -a template ${i}
#	cd ${i}
#	sed -i "s/index/${i}/g" 3.com
#	sed -i "s/index/${i}/g" job.slurm
#	cd ../
#done

#for ((i=1; i<=9; i++))
#do
#	echo ${i}
#	cp template/Bi.pp ${i}/.
#	cp template/job.slurm ${i}/.
#	cd ${i}
#	sbatch job.slurm
#	cd ../
#done

for ((i=1; i<=9; i++))
do
	echo ${i}
	cd ${i}
	cat 3.csv >> ../3.csv
	cd ../
done

