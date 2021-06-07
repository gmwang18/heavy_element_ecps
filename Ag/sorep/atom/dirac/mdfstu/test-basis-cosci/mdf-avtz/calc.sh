#!/bin/bash

HOME=`pwd`
rm states.spect
rm states.gap 

#calc="ae"

declare -a states=("gs" "ea" "ex" "ip1" "ip2")

for i in "${states[@]}"
do

#	pam --noarch --gb=2.0 --inp=$i.inp --mol=ae.mol

	lineBegin=$(grep -n 'Total Energy'  $i''*.out | head -n 1 | cut -d: -f1)
	lineEnd=$(grep -n 'Total average' $i''*.out | head -n 1 | cut -d: -f1)
	
	if [ -z $lineBegin ]
		then
		#### Read the calculation without SO splitting ####
		echo "$i state, No SO splitting in this state"
		grep 'Total energy' $i''*.out | head -n 1 | awk '{print $4}' > $i.dat
		awk 'NR==1{print}' $i.dat >> states.spect
		else
		#### Read the calculation with SO splitting ####
		echo "$i state, SO split reading..."
		lineSOBegin="$[lineBegin + 2]"
		lineSOEnd="$[lineEnd - 3]"
		awk "NR>=$lineSOBegin&&NR<=$lineSOEnd{print}" $i''*.out | awk '{print $4}' > $i.dat
		awk 'NR==1{print}' $i.dat >> states.spect
	fi
done


gs=`awk 'NR==1{print $1}' states.spect`
awk -v ref=$gs '{printf("%.6f\n",($1-ref)*27.211386)}' states.spect > states.gap
for i in "${states[@]}"
do
	linenum=$(grep "" -c $i.dat)
	if [ $linenum != 1 ]
	then
		ref=`awk 'NR==1{print $1}' $i.dat`
		awk -v ref=$ref '{printf("%.6f\n",($1-ref)*27.211386)}' $i.dat >> states.gap
	fi
done

rm -r DIRAC*


