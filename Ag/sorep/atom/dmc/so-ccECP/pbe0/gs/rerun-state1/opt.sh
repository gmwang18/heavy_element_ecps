

#srun -n 2048 -c 1 --cpu_bind=threads qwalk-so Ag.df
srun -n 2048 -c 1 --cpu_bind=threads qwalk-so Ag.opt2

python add3bodyjs.py

srun -n 2048 -c 1 --cpu_bind=threads qwalk-so Ag.opt3

sed 's/OPTIMIZEBASIS//g' Ag.opt3.wfout > fixed_basis.wfout

srun -n 2048 -c 1 --cpu_bind=threads qwalk-so Ag.linear

srun -n 2048 -c 1 --cpu_bind=threads qwalk-so Ag.dmc

