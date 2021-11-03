#!/bin/bash -l
#SBATCH -J bk2.1_4
#SBATCH -q regular
#!SBATCH -q debug
#SBATCH -N 1
#!SBATCH -n 16
#SBATCH -C haswell
#SBATCH -t 0:30:00
#SBATCH -o slurm.o%j

module load molpro

molpro -n 12 3.com

