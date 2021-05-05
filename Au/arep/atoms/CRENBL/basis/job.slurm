#!/bin/bash -l
#SBATCH -J CRENBL
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:30:00
#SBATCH -o test_molpro.o%j

module load molpro
molpro -n 24 -s 3.com
