#!/bin/bash -l
#SBATCH -J Au_4
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 04:00:00
#SBATCH -o Au_DKH.o%j

module load molpro

molpro -n 24 -s 3.com
