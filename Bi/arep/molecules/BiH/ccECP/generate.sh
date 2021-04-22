#!/usr/bin/env bash

for ((i=1; i<=10; i++))
do
	echo ${i}
	#mkdir ${i}
	cp template/*.pp ${i}/
	cd ${i}
	sed -i "s/index/${i}/g" 3.com
	sed -i "s/index/${i}/g" job.slurm
	cd ../
done

