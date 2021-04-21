#!/bin/bash -l
#SBATCH -J UC
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 06:30:00
#SBATCH -o Au_DKH.o%j

module load molpro

molpro -n 16 -s 3.com
