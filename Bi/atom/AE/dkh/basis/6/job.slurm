#!/bin/bash -l
#SBATCH -J Bi_6
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 01:00:00
#SBATCH -o Bi_DKH.out
#!SBATCH -o Bi_DKH.o%j

module load molpro

molpro -n 12 -s 3.com

