#!/bin/bash -l
#SBATCH -J Bi_ECP
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:30:00
#SBATCH -o Bi_DKH.out
#!SBATCH -o Bi_DKH.o%j

module load molpro

molpro -n 6 -s 3.com

