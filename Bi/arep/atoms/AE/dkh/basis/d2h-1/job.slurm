#!/bin/bash -l
#SBATCH -J Bi_1
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 01:20:00
#SBATCH -o Bi_DKH.out
#!SBATCH -o Bi_DKH.o%j

module load molpro

molpro -n 12 3.com

