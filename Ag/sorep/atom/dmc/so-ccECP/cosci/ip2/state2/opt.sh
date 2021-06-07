
HOME=`pwd`


aprun -n 512 -N 64 qwalk-so Ag.opt 

sed 's/OPTIMIZEBASIS//g' Ag.opt.wfout > fixed_basis.wfout

aprun -n 512 -N 64 qwalk-so Ag.linear 

