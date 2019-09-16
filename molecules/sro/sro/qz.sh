#!/bin/bash -l
#This script is written to collect the data of QZ basis binding energy


HOME=`pwd`

rm qzbind
for j in AE UC MDFSTU MWBSTU soft-stu-mod CRENBL LANL2DZ hard-stu-mod soft-d-inclu
do
echo r bind > $HOME/$j/qzbind
for i in $(seq 1.40 0.10 2.30 )
do
cd $HOME/$j/r_$i
Ebind=$(awk '{print $4}' qz.table1.txt)
echo $i $Ebind >> $HOME/$j/qzbind
done
cat $HOME/$j/qzbind
done

