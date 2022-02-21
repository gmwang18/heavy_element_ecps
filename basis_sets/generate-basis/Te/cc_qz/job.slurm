#!/bin/bash -l
#SBATCH -J cc_qz
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:40:00
#SBATCH -o slurm.out

module load molpro

molpro -s -n 16 atom.com

