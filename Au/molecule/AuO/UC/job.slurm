#!/bin/bash -l
#SBATCH -J UC
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:30:00
#SBATCH -o Au_DKH.out
#!SBATCH -o Au_DKH.o%j

module load molpro

molpro -n 24 atom.com

