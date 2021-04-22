#!/usr/bin/env bash

for i in 1 6
do
	echo ${i}
	cp template/Bi.pp ${i}/.
	#cp template/job.slurm ${i}/.
	cd ${i}
	sbatch job.slurm
	cd ../
done

