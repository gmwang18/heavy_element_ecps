#!/usr/bin/env bash

for ((i=1; i<=8; i++))
do
	echo ${i}
	cp template/Bi.pp ${i}/.
	#cp template/job.slurm ${i}/.
	cd ${i}
	sbatch job.slurm
	cd ../
done

