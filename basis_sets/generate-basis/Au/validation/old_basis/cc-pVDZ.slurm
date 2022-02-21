#!/bin/bash -l
#SBATCH -J cc-pVDZ_stu_val
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:10:00
#SBATCH -o cc-pVDZ.out

module load molpro
molpro -n 12 cc-pVDZ.com
