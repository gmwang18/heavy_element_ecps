HOME=/projects/PSFMat_2/gwang18/projects/so-ccecp/bi-soc/soc/dmc/atom/so-ccECP/gs/

cd $HOME/state3/
aprun -n 512 -N 64 qwalk-so Bi.dmc &
sleep 1

cd $HOME/state4/
aprun -n 512 -N 64 qwalk-so Bi.dmc &
sleep 1

cd $HOME/state5/
aprun -n 512 -N 64 qwalk-so Bi.dmc &
wait

