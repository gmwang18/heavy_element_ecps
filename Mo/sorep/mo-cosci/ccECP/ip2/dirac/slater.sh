#!/usr/bin/bash

sed -n '14517,14544p' ip2_pp.out &> multidets.dat
python slater.py &> ../state1/slater.temp

sed -n '14559,14580p' ip2_pp.out &> multidets.dat
python slater.py &> ../state2/slater.temp

sed -n '14595,14624p' ip2_pp.out &> multidets.dat
python slater.py &> ../state3/slater.temp

sed -n '14639,14660p' ip2_pp.out &> multidets.dat
python slater.py &> ../state4/slater.temp

sed -n '14675,14704p' ip2_pp.out &> multidets.dat
python slater.py &> ../state5/slater.temp

