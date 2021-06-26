#!/usr/bin/env bash

for ((i=1; i<=6; i++))
do
	echo ${i}
	cp template/Ir.pp ${i}/.
	#cp template/job.slurm ${i}/.
	cd ${i}
	sbatch job.slurm
	cd ../
done

