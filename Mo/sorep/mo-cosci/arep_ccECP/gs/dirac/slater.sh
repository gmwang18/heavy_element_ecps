#!/usr/bin/bash

sed -n '22421,22452p' final_gs_pp.out &> multidets.dat
python slater.py &> ../state2/slater.temp

sed -n '22469,22484p' final_gs_pp.out &> multidets.dat
python slater.py &> ../state3/slater.temp

sed -n '22501,22516p' final_gs_pp.out &> multidets.dat
python slater.py &> ../state4/slater.temp

sed -n '22533,22556p' final_gs_pp.out &> multidets.dat
python slater.py &> ../state5/slater.temp

sed -n '22573,22596p' final_gs_pp.out &> multidets.dat
python slater.py &> ../state6/slater.temp

sed -n '22613,22662p' final_gs_pp.out &> multidets.dat
python slater.py &> ../state7/slater.temp

