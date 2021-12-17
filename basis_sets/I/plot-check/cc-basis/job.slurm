#!/bin/bash -l
#SBATCH -J basis_check
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:20:00
#SBATCH -o slurm.out

module load molpro

molpro -s -n 16 dz.com
molpro -s -n 16 tz.com
molpro -s -n 16 qz.com
molpro -s -n 16 5z.com
molpro -s -n 16 6z.com

