#!/bin/bash -l
#SBATCH -J AE_NR
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:20:00
#SBATCH -o test_molpro.o%j

module load molpro
molpro -n 12 -s f_tz.com
