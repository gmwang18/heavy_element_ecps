HOME=`pwd`


#srun -n 512 -c 1 --cpu_bind=threads qwalk-so Ag2.hf

srun -n 512 -c 1 --cpu_bind=threads qwalk-so Ag2.opt 

sed 's/OPTIMIZEBASIS//g' Ag2.opt.wfout > fixed_basis.wfout

srun -n 512 -c 1 --cpu_bind=threads qwalk-so Ag2.linear 

