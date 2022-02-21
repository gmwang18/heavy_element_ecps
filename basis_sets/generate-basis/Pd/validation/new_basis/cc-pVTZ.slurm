#!/bin/bash -l
#SBATCH -J cc-pVTZ_validation
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:10:00
#SBATCH -o cc-pVTZ.out

module load molpro
molpro -n 12 cc-pVTZ.com
