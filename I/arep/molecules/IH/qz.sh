#!/bin/bash -l
#This script is written to collect the data of QZ basis binding energy


HOME=`pwd`

for j in ae  crenbl  lanl2dz  mdfstu  sbkjc  uc  i6
do
rm $HOME/$j/qzbind
echo r bind > $HOME/$j/qzbind
for i in $(seq 1.20 0.10 1.80 )
do
cd $HOME/$j/r_$i
Ebind=$(awk '{print $4}' qz.table1.txt)
echo $i $Ebind >> $HOME/$j/qzbind
done
cat $HOME/$j/qzbind
done
