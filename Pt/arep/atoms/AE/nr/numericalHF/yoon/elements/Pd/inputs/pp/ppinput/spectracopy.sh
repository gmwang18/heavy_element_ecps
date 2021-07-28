#! /bin/bash

rm pp_spectra.dat
HOME=`pwd`
cd ../yoon-modified
gfortran -w hfmesh.f
cd $HOME
cp ../pp.d ../yoon-modified/pp.d
for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13
do
cp pp$i.d ../yoon-modified/ip.d
cd ../yoon-modified/
./a.out &> energy.output
grep 'TOTAL' energy.output | awk -F '-' {'printf("%.6f\n",-$3)'} >> $HOME/pp_spectra.dat
cd $HOME
done
Ecore=`awk 'NR==1{print $1}' pp_spectra.dat`
Eground=`awk 'NR==1{print $2}' pp_spectra.dat`
Evv=`bc <<< "$Eground - $Ecore"`
echo Evv = $Evv
Eref=`awk 'NR==1{print $1 }' pp_spectra.dat`
#Eref2=`awk -v ref1=$Eref1 'NR==1{printf"%.6f\n",$1-ref1}'`
awk -v ref=$Eref 'NR>1{printf"%.6f\n",$1-ref}' pp_spectra.dat > spectra.pp
Ecore2=`awk 'NR==1{print $1 }' newspect.ae`
paste newspect.ae spectra.pp >temp.dat
awk 'NR<6{d=($2-$1)*1;printf"%.6f\n",(d>0)?d:-d}' temp.dat > errors.d 
awk 'NR>5&&NR<15{d=($2-$1)*1.0;printf"%.6f\n",(d>0)?d:-d}' temp.dat >> errors.d
MAD=`awk 'BEGIN {sum = 0}; {sum+=$1}; END {printf"%.6f", sum/13}' errors.d`
SOQ=`awk 'BEGIN {sum = 0}; {sum+=$1*$1}; END {printf"%.6f", sum}' errors.d`
echo MAD = $MAD
echo SOQ = $SOQ
#cat spectra.pp
#echo Ecore2 = $Ecore2
cat errors.d
