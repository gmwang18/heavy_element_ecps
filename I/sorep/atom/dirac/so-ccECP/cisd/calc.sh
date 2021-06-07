#!/bin/bash

HOME=`pwd`
rm states.spect
rm states.gap 

#calc="ae"

declare -a states=("gs" "ea" "ip1" "ip2")
#declare -a states=("gs")

for i in "${states[@]}"
do

	pam --noarch --gb=6 --inp=$i.inp --mol=tz.mol

	lineBegin=$(grep -n 'Final CI'  $i''*.out | head -n 1 | cut -d: -f1)
	line="$(awk "NR>=$lineBegin && NR<=$[lineBegin + 1] {print}" $i''*.out | tr -d '\n')"
	columns="$(echo $line | wc -w)"
	multi_num="$[columns - 4]"

	
	if [ $multi_num == 1 ]
		then
		#### Read the calculation without SO splitting ####
		echo "$i state, No SO splitting in this state"
		echo $line | awk '{print $5}' > $i.dat
		awk 'NR==1{print}' $i.dat >> states.spect
	else
		#### Read the calculation with SO splitting ####
		echo "$i state, SO split reading..."
		rm $i.dat
		for j in $(seq 5 $columns)
		do
			echo $line | awk -v var=$j '{print $var}' >> $i.dat
		done
		awk 'NR==1{print}' $i.dat >> states.spect
	fi
done


gs=`awk 'NR==1{print $1}' states.spect`
awk -v ref=$gs '{printf("%.6f\n",($1-ref)*27.211386)}' states.spect > states.gap
for i in "${states[@]}"
do
	linenum=$(grep "" -c $i.dat)
	echo $linenum
	if [ $linenum != 1 ]
	then
		ref=`awk 'NR==1{print $1}' $i.dat`
		awk -v ref=$ref '{printf("%.6f\n",($1-ref)*27.211386)}' $i.dat >> states.gap
	fi
done

rm -r DIRAC*


