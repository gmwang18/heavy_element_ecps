
srun -n 512 -c 1 --cpu_bind=threads qwalk-so Te.df

srun -n 512 -c 1 --cpu_bind=threads qwalk-so Te.opt2
python add3bodyjs.py
srun -n 512 -c 1 --cpu_bind=threads qwalk-so Te.opt3

sed 's/OPTIMIZEBASIS//g' Te.opt3.wfout > fixed_basis.wfout

srun -n 512 -c 1 --cpu_bind=threads qwalk-so Te.linear

exit
