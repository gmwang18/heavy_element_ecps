#!/bin/bash -l

HOME=`pwd`


srun -n 512 -c 1 --cpu_bind=threads qwalk-so I.opt 

sed 's/OPTIMIZEBASIS//g' I.opt.wfout > fixed_basis.wfout

srun -n 512 -c 1 --cpu_bind=threads qwalk-so I.linear 

sbatch $HOME/jobdmc
