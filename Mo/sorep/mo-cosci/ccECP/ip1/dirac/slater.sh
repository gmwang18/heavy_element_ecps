#!/usr/bin/bash

sed -n '29547,29572p' ip1_pp.out &> multidets.dat
python slater.py &> ../state1/slater.temp

sed -n '29587,29616p' ip1_pp.out &> multidets.dat
python slater.py &> ../state2/slater.temp

sed -n '29631,29657p' ip1_pp.out &> multidets.dat
python slater.py &> ../state3/slater.temp

sed -n '29672,29700p' ip1_pp.out &> multidets.dat
python slater.py &> ../state4/slater.temp

sed -n '29715,29744p' ip1_pp.out &> multidets.dat
python slater.py &> ../state5/slater.temp

