#!/usr/bin/env bash

for ((i=1; i<=8; i++))
do
	echo ${i}
	#cp template/job.slurm ${i}/.
	cd ${i}
	rm *.out*
	rm *.xml*
	rm *.csv
	cd ../
done

