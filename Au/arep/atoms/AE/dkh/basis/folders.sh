#!/usr/bin/env bash

for ((i=1; i<=14; i++))
do
        echo ${i}
        #mkdir ${i}
        #cp 3.com ${i}
        #cp *.basis ${i}
        #cp states.proc ${i}
        #cp job.slurm ${i}
        cd ${i}
        #sed -i "s/my_state/${i}/g" 3.com
        #sbatch job.slurm
        cat 3.csv >> ../3.csv
        cd ../
done


