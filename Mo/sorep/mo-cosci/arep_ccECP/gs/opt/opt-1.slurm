#!/bin/bash -l
#SBATCH -J C2H2_OPT-1
#SBATCH -q low
#SBATCH -N 8
#SBATCH -C knl
#SBATCH -t 00:30:00
#SBATCH -o so_qwalk.o%j

HOME=`pwd`


srun -n 512 -c 1 --cpu_bind=threads qwalk-so-cori Mo.opt-1


