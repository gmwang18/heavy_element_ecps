#!/bin/bash -l
#SBATCH -J AE_BiH_2.2
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 02:30:00
#SBATCH -o Bi_DKH.out
#!SBATCH -o Bi_DKH.o%j

module load molpro

molpro -n 12 -s 3.com

