#!/bin/bash -l
#This script is written to collect the data of QZ basis binding energy


HOME=`pwd`

rm 5zbind
for j in AE UC MDFSTU SBKJC CRENBL LANL2DZ ag9 cody-stu-mod cody-stu-mod-no-d
do
echo r bind > $HOME/$j/5zbind
for i in $(seq 1.60 0.10 2.40 )
do
cd $HOME/$j/r_$i
Ebind=$(awk '{print $4}' 5z.table1.txt)
echo $i $Ebind >> $HOME/$j/5zbind
done
cat $HOME/$j/5zbind
done

