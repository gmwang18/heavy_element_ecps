#!/bin/bash -l
#SBATCH -J cc-pVQZ_stu_val
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:10:00
#SBATCH -o cc-pVQZ.out

module load molpro
molpro -n 12 cc-pVQZ.com
