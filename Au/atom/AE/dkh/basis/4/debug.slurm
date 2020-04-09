#!/bin/bash -l
#SBATCH -J Au_DKH
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:20:00
#SBATCH -o Au_DKH.o%j

module load molpro

molpro -n 24 -s 3.com
