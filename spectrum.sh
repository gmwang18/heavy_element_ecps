#!/usr/bin/env bash

HOME=`pwd`
#echo ${HOME}

declare -a atoms=("Ag" "Au" "Bi" "I" "Ir" "Mo" "Pd" "W")

for i in "${atoms[@]}"
do
        echo ${i}
        cd ${HOME}/${i}/arep/atoms
        python gaps.py
        cp ${i}.csv ${HOME}/data_analysis/arep/atomic/.
done

