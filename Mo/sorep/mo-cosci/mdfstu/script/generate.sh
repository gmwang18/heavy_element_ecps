#!/usr/bin/bash
HOME=`pwd`
for i in "gs" "ea" "ex" "ip1" "ip2" "4p" "p1"
do
	cp -r ../ccECP/$i $HOME/$i
	cp $HOME/pp.mol $HOME/$i/dirac
done

