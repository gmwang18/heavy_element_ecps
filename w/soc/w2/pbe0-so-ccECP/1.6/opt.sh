#!/bin/bash -l

HOME=`pwd`

srun -n 512 -c 1 --cpu_bind=threads qwalk-so W2.opt 

sed 's/OPTIMIZEBASIS//g' W2.opt.wfout > fixed_basis.wfout

srun -n 512 -c 1 --cpu_bind=threads qwalk-so W2.linear 

sbatch $HOME/jobdmc
