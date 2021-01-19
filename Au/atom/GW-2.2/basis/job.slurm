#!/bin/bash -l
#SBATCH -J GW-2.2
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 01:00:00
#SBATCH -o test_molpro.o%j

module load molpro
molpro -n 24 -s 3.com
