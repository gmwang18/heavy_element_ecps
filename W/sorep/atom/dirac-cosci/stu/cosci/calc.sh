#!/bin/bash

HOME=`pwd`
rm states*
rm spectra.dat
rm *.spect
#rm *.out
#rm *DFCOEF*

calc="pp"

num_charge_choice=5

declare -a states=("gs" "ea" "ex" "ip1" "ip2" "s2-p-ex" "s2-f-ex" "s2p5")
declare -a mult_num=(6 1 2 6 6 2 2 2)


#pam --noarch --gb=6.0 --inp=core.inp --mol=$calc.mol --get "DFCOEF=coreDFCOEF"

num_states=${#states[@]}
#for i in "${states[@]}"
for (( i=0; i<$num_states; i++ ))
do
	state=${states[$i]}
	#pam --noarch --gb=2.0 --inp=$state.inp --mol=$calc.mol --put "coreDFCOEF=DFCOEF"

	lineBegin=$(grep -n 'Total Energy'  $state''_$calc.out | head -n 1 | cut -d: -f1)
	lineEnd=$(grep -n 'Total average' $state''_$calc.out | head -n 1 | cut -d: -f1)
	
	if [ -z $lineBegin ]
	then
		#### Read the calculation without SO splitting ####
		echo "$state state, No SO splitting in this state"
		grep 'Total energy' $state''_$calc.out | head -n 1  > energy_$state.dat
	else
		#### Read the calculation with SO splitting ####
		echo "$state state, SO split reading..."
		awk "NR>=$lineBegin&&NR<=$lineEnd{print}" $state''_$calc.out > energy_$state.dat
	fi
	#### I have captured the calculation results from each state #####
	#### Now I will capture the multiplit energies from each state ####

	if [ -z $lineBegin ]
	then
		echo "Full shell states, Pure singlet state"
		awk 'NR==1{print $4}' energy_$state.dat > mult_$state.dat
		awk 'NR==1{print}' mult_$state.dat >> states_$state.spect
	else
		echo "I might have to read multiplet states from output and delete the degenerate states"
		filelen=$(grep -c "" energy_$state.dat)
		lineSOend="$[filelen - 2]"
		awk "NR>2&&NR<$lineSOend{print $4}" energy_$state.dat | awk '{print $4}' > mult_$state.dat
		len="$[filelen - 5]"

		j=0
		k=1
		#for (( k=1; k<=$len; k++ ))
		while [ $j -lt ${mult_num[$i]} ]
		do
			echo ${mult_num[$i]}
			if [ $k == 1 ]
			then 
				last_mult_state=$(awk 'NR==1{print}' mult_$state.dat)
				echo $last_mult_state >> states_$state.spect
				j=$[$j+1]
				k=$[$k+1]
			else
				current_mult_state=$(awk "NR==$k{print}" mult_$state.dat)
				diff=$(bc <<< "$current_mult_state - $last_mult_state")
				if (( $(echo "$diff > 0.00005" |bc -l) ))
				then
					#### last and current states are not degenerate ###
					last_mult_state=$current_mult_state
					j=$[$j+1]
					echo $last_mult_state >> states_$state.spect
				fi
				k=$[$k+1]
			fi
		done	

	fi
done


gs=`awk 'NR==1{print $1}' states_${states[0]}.spect`
for i in "${states[@]}"
do
	awk -v ref=$gs 'NR==1{printf("%.6f\n",($1-ref)*27.211386)}' states_$i.spect >> charged_states.spect
done

awk "NR<=$num_charge_choice{print $1}" charged_states.spect > spectra.dat

for i in "${states[@]}"
do
	linenum=$(grep -c "" states_$i.spect)
	if [ $linenum != 1 ]
	then
		ref=`awk 'NR==1{print $1}' states_$i.spect`
		awk -v ref=$ref '{printf("%.6f\n",($1-ref)*27.211386)}' states_$i.spect >> spectra.dat
	fi
done



rm mult_*
rm energy*.dat
rm -r DIRAC*

