#!/usr/bin/env bash                                                                                                                                                                 

rm bind.csv

HOME=`pwd`
for i in 1.20 1.30 1.40 1.50 1.60 1.70 1.80
do
	cd $HOME/r_$i
	echo $i
	tail qz.table1.txt >> ../bind.csv
done

cd $HOME
sed -i "s/ //g" bind.csv
sed -i "/^$/d" bind.csv
sed -i "/SCF,CCSD/d" bind.csv
sed -i '1s/^/r bind\n/' bind.csv
