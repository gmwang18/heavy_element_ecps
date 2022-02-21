#!/bin/bash -l
#SBATCH -J core_5z
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:30:00
#SBATCH -o slurm.out

module load molpro

molpro -s -n 16 atom.com

