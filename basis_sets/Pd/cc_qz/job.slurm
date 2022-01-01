#!/bin/bash -l
#SBATCH -J cc_5z
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 01:30:00
#SBATCH -o slurm.out

module load molpro

molpro -s -n 16 atom.com

