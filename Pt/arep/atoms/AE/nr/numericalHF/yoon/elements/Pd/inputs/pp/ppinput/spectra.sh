#! /bin/bash

rm pp_spectra.dat
HOME=`pwd`
cd ../yoon-modified
gfortran -w hfmesh.f
cd $HOME
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13
do
cp pp$i.d ../yoon-modified/ip.d
cd ../yoon-modified/
./a.out &> energy.output
grep 'TOTAL' energy.output | awk -F '-' {'printf("%.6f\t%.6f\n", -$2 ,-$3)'} >> $HOME/pp_spectra.dat
cd $HOME
done
Ecore=`awk 'NR==1{print $1}' pp_spectra.dat`
Eground=`awk 'NR==2{print $1}' pp_spectra.dat`
Evv=`bc <<< "$Eground - $Ecore"`
echo Evv = $Evv
Eref1=`awk 'NR==1{print $1 }' pp_spectra.dat`
Eref2=`awk 'NR==1{print $2 }' pp_spectra.dat`
awk -v ref1=$Eref1 -v ref2=$Eref2 'NR>1{printf"%.6f\t%.6f\n",$1-ref1,$2-ref2}' pp_spectra.dat > spectra.pp
#head -n1 spectra.pp
# Erefmore=`awk 'NR==1{print $1}' pp_spectra.dat`
# awk -v ref=$Erefmore 'NR>1{printf"%.6f\n",$1-ref}' pp_spectra.dat > pp.data

cat spectra.pp
