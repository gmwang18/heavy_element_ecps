#!/bin/bash -l
#This script is written to collect the data of QZ basis binding energy

HOME=`pwd`

for j in AE  ccECP  CRENBL  LANL2  MDFSTU  SBKJC  tz.sh  UC
	do
	rm $HOME/$j/tzbind
	echo r bind > $HOME/$j/tzbind
	for i in $(seq 1.200 0.100 1.800 )
		do
		cd $HOME/$j/$i
		Ebind=$(awk '{print $4}' qz.table1.txt)
		echo $i $Ebind >> $HOME/$j/qzbind
	done
	cat $HOME/$j/qzbind
done
