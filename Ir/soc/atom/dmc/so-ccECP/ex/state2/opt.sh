
srun -n 512 -c 1 --cpu_bind=threads qwalk-so Ir.df

srun -n 512 -c 1 --cpu_bind=threads qwalk-so Ir.opt2
python add3bodyjs.py
srun -n 512 -c 1 --cpu_bind=threads qwalk-so Ir.opt3

sed 's/OPTIMIZEBASIS//g' Ir.opt3.wfout > fixed_basis.wfout

srun -n 512 -c 1 --cpu_bind=threads qwalk-so Ir.linear

exit
