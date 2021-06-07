HOME=`pwd`


#srun -n 2176 -c 1 --cpu_bind=threads qwalk-so Bi.df

srun -n 2176 -c 1 --cpu_bind=threads qwalk-so Bi.opt 

sed 's/OPTIMIZEBASIS//g' Bi.opt.wfout > fixed_basis.wfout

srun -n 2176 -c 1 --cpu_bind=threads qwalk-so Bi.linear 

