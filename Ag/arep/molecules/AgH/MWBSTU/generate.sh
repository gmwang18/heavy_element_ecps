#!/usr/bin/env bash

for ((i=1; i<=10; i++))                                                                                                                                                              
do
	echo ${i}
	cp -a template ${i}
	cd ${i}
	sed -i "s/index/${i}/g" 5.com
	sed -i "s/index/${i}/g" job.slurm
	cd ../
done

