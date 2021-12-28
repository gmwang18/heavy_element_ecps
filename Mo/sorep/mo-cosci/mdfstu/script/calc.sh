#!/bin/bash

HOME=`pwd`
rm $HOME/../spectra.dat

declare -a states=("gs" "ex" "ea" "ip1" "ip2" "p1" "4p")
declare -a mult_num=(7 5 1 5 5 2 2)
declare -a totalstates=("gs" "ex" "ea" "ip1" "ip2")
declare -a multistates=("gs" "ex" "ip1" "ip2" "p1" "4p")

num_states=${#states[@]}

for i in ${states[@]}
do 
	rm $HOME/../$i/spect_$i.dat
done

for (( i=0; i<$num_states; i++))
do
        state=${states[$i]}
        num=${mult_num[$i]}

        for ((j=1; j<=$num; j++))
	do
                gosling-so-cori $HOME/../$state/state$j/Mo.dmc.log > $HOME/../$state/tmp.dat 
		grep -n 'total_energy0' $HOME/../$state/tmp.dat | awk '{ print $2,$4 }' >> $HOME/../$state/spect_$state.dat
		rm $HOME/../$state/tmp.dat
        done
done

gs=`awk 'NR==1{print $1}' $HOME/../gs/spect_gs.dat`
echo $gs

for i in "${totalstates[@]}"
do
	awk -v ref=$gs 'NR==1{printf("%.6f\n",($1-ref)*27.211386)}' $HOME/../$i/spect_$i.dat >> $HOME/../spectra.dat
done

for i in "${multistates[@]}"
do
	ref=`awk 'NR==1{print $1}' $HOME/../$i/spect_$i.dat`
	awk -v ref=$ref '{printf("%.6f\n",($1-ref)*27.211386)}' $HOME/../$i/spect_$i.dat >> $HOME/../spectra.dat
done


