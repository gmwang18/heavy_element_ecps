#!/bin/bash -l
#SBATCH -J AuH_2.0
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:10:00
#SBATCH -o Au_DKH.out
#!SBATCH -o Au_DKH.o%j

module load molpro

molpro -n 24 -s 3.com

