#!/usr/bin/bash

for i in 1 2 3 4 5
do
	mv Mo_state$i.slater ../state$i/Mo.slater
	cp new.orb ../state$i/Mo.orb
done
