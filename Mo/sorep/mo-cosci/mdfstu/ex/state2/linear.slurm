#!/bin/bash -l
#SBATCH -J Mo_DMC
#SBATCH -q low
#SBATCH -N 16
#SBATCH -C knl
#SBATCH -t 01:00:00
#SBATCH -o so_qwalk.o%j

HOME=`pwd`


srun -n 2048 -c 1 --cpu_bind=threads qwalk-so-cori Mo.linear


~                                                     
