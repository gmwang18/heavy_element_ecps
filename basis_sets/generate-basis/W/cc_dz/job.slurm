#!/bin/bash -l
#SBATCH -J cc_tz
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:25:00
#SBATCH -o slurm.out

module load molpro

molpro -s -n 16 atom.com

