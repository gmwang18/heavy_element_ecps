srun -n 1024 -c 1 --cpu_bind=threads qwalk-so Au2.df

srun -n 1024 -c 1 --cpu_bind=threads qwalk-so Au2.opt2
python add3bodyjs.py
srun -n 1024 -c 1 --cpu_bind=threads qwalk-so Au2.opt3

sed 's/OPTIMIZEBASIS//g' Au2.opt3.wfout > fixed_basis.wfout

srun -n 1024 -c 1 --cpu_bind=threads qwalk-so Au2.linear

sbatch jobdmc

exit
