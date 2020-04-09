#!/bin/bash -l
#SBATCH -J 1.9
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 09:30:00
#SBATCH -o Au_DKH.out
#!SBATCH -o Au_DKH.o%j

module load molpro

molpro -n 12 -s 3.com

