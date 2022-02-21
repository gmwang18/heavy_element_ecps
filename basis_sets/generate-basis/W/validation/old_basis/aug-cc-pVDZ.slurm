#!/bin/bash -l
#SBATCH -J aug-cc-pVDZ_stu_val
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:10:00
#SBATCH -o aug-cc-pVDZ.out

module load molpro
molpro -n 12 aug-cc-pVDZ.com
