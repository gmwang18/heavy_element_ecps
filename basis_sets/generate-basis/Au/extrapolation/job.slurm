#!/bin/bash -l
#SBATCH -J Sc_uccsd-t
#SBATCH -q shared
#SBATCH -n 1
#SBATCH -C haswell
#SBATCH -t 00:49:00
#!SBATCH -o slurm.o%j
#SBATCH -o Sc_uccsd-t.out

module load molpro

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=5; i++))
do
	molpro -n 1 ${i}.com
done


