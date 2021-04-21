#!/usr/bin/env bash

for ((i=1; i<=8; i++))
do
	echo ${i}
	cp -a template ${i}
	cd ${i}
	sed -i "s/index/${i}/g" 3.com
	sed -i "s/index/${i}/g" job.slurm
	cd ../
done

