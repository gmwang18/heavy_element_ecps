#!/bin/bash -l
#SBATCH -J ECP_1
#SBATCH -q debug
#SBATCH -N 1
#!SBATCH -n 16
#SBATCH -C haswell
#SBATCH -t 0:30:00
#SBATCH -o slurm.o%j

module load molpro

molpro -n 12 3.com

