#!/bin/bash -l
#SBATCH -J AuH_LANL2DZ
#SBATCH -q regular
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 04:30:00
#SBATCH -o Au_DKH.out
#!SBATCH -o Au_DKH.o%j

module load molpro

molpro -n 24 -s 3.com

