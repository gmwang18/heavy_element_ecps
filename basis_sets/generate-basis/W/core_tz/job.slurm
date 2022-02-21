#!/bin/bash -l
#SBATCH -J core_tz
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 02:00:00
#SBATCH -o slurm.out

module load molpro

molpro -s -n 16 atom.com

