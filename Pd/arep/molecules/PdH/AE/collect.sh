#!/bin/bash -l                                                                                                                                                                      

HOME=`pwd`

rm tz.table1.txt
for i in $(seq 1.679 -0.050 1.179 )
do
	cd ${HOME}/$i
	cat tz.table1.txt >> ../tz.table1.txt
done
