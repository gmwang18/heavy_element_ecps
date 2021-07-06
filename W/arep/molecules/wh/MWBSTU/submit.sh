#!/usr/bin/env bash

for ((i=1; i<=9; i++))                                                                                                                                                              
do
	echo ${i}
	cp template/W.pp ${i}/.
	cp template/job.slurm ${i}/.
        sed -i "s/index/${i}/g" ${i}/job.slurm                                                                                                                                      
	cd ${i}
	sbatch job.slurm
	cd ../
done

