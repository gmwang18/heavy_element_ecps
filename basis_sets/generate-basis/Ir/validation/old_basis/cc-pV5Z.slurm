#!/bin/bash -l
#SBATCH -J cc-pV5Z_stu_val
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:10:00
#SBATCH -o cc-pV5Z.out

module load molpro
molpro -n 12 cc-pV5Z.com
