#!/bin/bash

equil=$(echo "1.2" | bc -l)
d=$(echo "0.10" | bc -l)

HOME=`pwd`

basefolder=$HOME/../
n=7

for ((i=0; i<=n; i++))
do
	r=$(echo "$equil+$i*$d" | bc -l)
	mkdir $basefolder/r_$r
	cp $HOME/job $basefolder/r_$r
	#cp $HOME/*.basis $basefolder/r_$r/
        sed 's/XZ/TZ/g' $HOME/template.com > $basefolder/r_$r/tz.com
	sed -i "s/length/$r/g" $basefolder/r_$r/*.com
done
