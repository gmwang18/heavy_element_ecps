#!/bin/bash -l
#SBATCH -J Mo_OPT2
#SBATCH -q debug
#SBATCH -N 8
#SBATCH -C knl
#SBATCH -t 00:30:00
#SBATCH -o so_qwalk.o%j

HOME=`pwd`


srun -n 512 -c 1 --cpu_bind=threads qwalk-so-cori Mo.opt2


~                                                     
