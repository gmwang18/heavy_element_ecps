#!/bin/bash -l
#This script is written to collect the data of QZ basis binding energy


HOME=`pwd`

rm tzbind
for j in AE UC MDFSTU MHFSTU CRENBL LANL2DZ chandler-stu-mod
do
echo r bind > $HOME/$j/tzbind
for i in $(seq 1.40 0.10 2.30 )
do
cd $HOME/$j/r_$i
Ebind=$(awk '{print $4}' tz.table1.txt)
echo $i $Ebind >> $HOME/$j/tzbind
done
cat $HOME/$j/tzbind
done

