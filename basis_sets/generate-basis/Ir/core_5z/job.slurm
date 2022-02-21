#!/bin/bash -l
#SBATCH -J core_5z
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 04:00:00
#SBATCH -o slurm.out

module load molpro

molpro -s -n 16 atom.com

