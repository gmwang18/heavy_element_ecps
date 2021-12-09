#!/bin/bash -l
#SBATCH -J aug-cc-pVQZ_validation
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:10:00
#SBATCH -o aug-cc-pVQZ.out

module load molpro
molpro -n 12 aug-cc-pVQZ.com
