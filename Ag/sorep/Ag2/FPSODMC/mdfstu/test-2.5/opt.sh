HOME=`pwd`


#aprun -n 512 -N 64 qwalk-so Ag2.df

aprun -n 512 -N 64 qwalk-so Ag2.opt 

sed 's/OPTIMIZEBASIS//g' Ag2.opt.wfout > fixed_basis.wfout

aprun -n 512 -N 64 qwalk-so Ag2.linear 

