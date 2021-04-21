#!/bin/bash -l
#SBATCH -J SBKJC
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 05:00:00
#SBATCH -o job.out

module load molpro

molpro -n 24 -s 3.com

