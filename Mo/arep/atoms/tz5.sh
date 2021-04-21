#!/bin/bash -l
#This script is written to collect the data of TZ basis binding energy


HOME=`pwd`

for j in crenbl  lanl2tz  mdfstu  ECP1.0 ECP2.0 ECP2.1  ECP2.3 ECP2.3test ECP2.4 regstu ECP2.4test ECP3.0 ECP3.1
do
	cp $HOME/crenbl/states.proc $HOME/$j/
	cp $HOME/crenbl/tz5.com $HOME/$j/
	cp $HOME/crenbl/job5 $HOME/$j/
	sbatch $HOME/$j/job5
done

