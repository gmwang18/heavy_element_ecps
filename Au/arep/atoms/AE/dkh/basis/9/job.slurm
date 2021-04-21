#!/bin/bash -l
#SBATCH -J Au_9
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 02:00:00
#SBATCH -o Au_DKH.o%j

module load molpro

molpro -n 8 -s 3.com
