#!/bin/bash -l
#SBATCH -J ECP_10
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:10:00
#SBATCH -o Bi_DKH.out
#!SBATCH -o Bi_DKH.o%j

module load molpro

molpro -n 24 -s 3.com

