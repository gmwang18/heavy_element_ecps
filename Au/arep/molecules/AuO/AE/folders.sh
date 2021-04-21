#!/usr/bin/env bash

#declare -a r=("1.5" "1.6" "1.7" "1.8" "1.9" "2.0" "2.1" "2.2")
declare -a r=("1.5" "1.6" "1.7" "1.8" "2.0" "2.1" "2.2")

for i in "${r[@]}"
do
        echo ${i}
        mkdir ${i}
        cp 3.com ${i}
        cp *.basis ${i}
        cp job.slurm ${i}
        cd ${i}
        sed -i "s/my_state/${i}/g" 3.com
        sed -i "s/my_state/${i}/g" job.slurm
        sbatch job.slurm
        #cat 3.csv >> ../3.csv
        cd ../
done

