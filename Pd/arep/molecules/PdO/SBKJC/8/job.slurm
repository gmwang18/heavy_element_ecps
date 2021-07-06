#!/bin/bash -l
#SBATCH -J SBK-PdO_8
#SBATCH -q regular
#!SBATCH -q debug
#SBATCH -N 1
#!SBATCH -n 16
#SBATCH -C haswell
#SBATCH -t 0:08:00
#SBATCH -o slurm.o%j

module load molpro

molpro -n 12 3.com

