#!/bin/bash -l                                                                                                                                                                      

HOME=`pwd`

rm tz.table1.txt
for i in $(seq 1.200 0.100 1.800 )
do
	cd ${HOME}/$i
	cat tz.table1.txt >> ../tz.table1.txt
done

