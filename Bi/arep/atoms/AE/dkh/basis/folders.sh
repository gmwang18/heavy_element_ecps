#!/usr/bin/env bash

for ((i=1; i<=15; i++))
do
        echo ${i}
        #mkdir ${i}
        #cp 3.com ${i}
        #cp *.basis ${i}
        #cp states.proc ${i}
        #cp job.slurm ${i}
        cd ${i}
        #sed -i "s/my_state/${i}/g" 3.com
        #sed -i "s/my_state/${i}/g" job.slurm
        #sbatch job.slurm
        #./job.slurm > log.out

        #tail 3.out
        #cat 3.csv
        tail 3.csv >> ../3.csv
        cd ../
done

