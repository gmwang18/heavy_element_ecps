#!/bin/bash -l
#SBATCH -J Bi_CC
#SBATCH -q shared
#SBATCH -n 8
#SBATCH -C haswell
#SBATCH -t 01:00:00
#!SBATCH -o slurm.o%j
#SBATCH -o job.out

module load molpro

#Cori there are 32 cores per node

molpro -s -n 4 5z.com

