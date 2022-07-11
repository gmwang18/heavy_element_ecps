#!/usr/bin/env bash

HOME=`pwd`
pp_library="/gpfs/alpine/mat151/proj-shared/aannabe/docs/pp_library/pseudopotentiallibrary"

declare -a ptable=("Bi" "Te" "I" "Mo" "W" "Ir" "Pd" "Ag" "Au")

for i in "${ptable[@]}"
do
    cp ${HOME}/${i}/${i}.ccECP.molpro ${pp_library}/recipes/${i}/ccECP/${i}.ccECP.molpro
    cp ${HOME}/${i}/${i}.ccECP.nwchem ${pp_library}/recipes/${i}/ccECP/${i}.ccECP.nwchem
    cp ${HOME}/${i}/${i}.ccECP.dirac  ${pp_library}/recipes/${i}/ccECP/${i}.ccECP.dirac
done

