#!/bin/bash -l
#SBATCH -J BiO_1.6_AE
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 24:00:00
#SBATCH -o Bi_DKH.out
#!SBATCH -o Bi_DKH.o%j

module load molpro

molpro -n 12 -s 3.com

