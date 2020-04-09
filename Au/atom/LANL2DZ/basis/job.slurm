#!/bin/bash -l
#SBATCH -J LANL2DZ
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 01:30:00
#SBATCH -o test_molpro.o%j

module load molpro
molpro -n 16 -s 3.com
