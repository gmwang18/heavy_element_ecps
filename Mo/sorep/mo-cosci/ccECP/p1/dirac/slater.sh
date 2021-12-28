#!/usr/bin/bash

sed -n '14517,14544p' p1_pp.out &> multidets.dat
python slater.py &> ../state1/slater.temp

sed -n '14559,14580p' p1_pp.out &> multidets.dat
python slater.py &> ../state2/slater.temp
