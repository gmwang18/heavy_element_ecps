#srun -n 512 -c 1 --cpu_bind=threads qwalk-so Au.hf

srun -n 512 -c 1 --cpu_bind=threads qwalk-so Au.opt2
python add3bodyjs.py
srun -n 512 -c 1 --cpu_bind=threads qwalk-so Au.opt3

sed 's/OPTIMIZEBASIS//g' Au.opt3.wfout > fixed_basis.wfout

srun -n 512 -c 1 --cpu_bind=threads qwalk-so Au.linear

sbatch jobdmc
