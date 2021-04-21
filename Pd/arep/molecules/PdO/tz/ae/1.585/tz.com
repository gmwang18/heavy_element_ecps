***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

set,dkroll=1,dkho=10,dkhp=4

basis={
include,c-Pd-aug-cc-pwCVTZ.basis
include,c-O-aug-cc-CVTZ.basis
}

OE=-75.09181489
PdE=-5044.366379

ne = 54
geometry={
        2
        PdO
        Pd 0.0 0.0 0.0
        O 0.0 0.0 1.585
}

A1=14
B1=6
B2=6
A2=2

{rks,pbe0
wf,nele=ne,spin=2,sym=2
occ,A1,B1,B2,A2
closed,A1-1,B1-1,B2,A2
}

{rhf
wf,nelec=ne,spin=2,sym=2
occ,A1,B1,B2,A2
closed,A1-1,B1-1,B2,A2
}

basis={
include,Pd-aug-cc-pwCVTZ.basis
include,O-aug-cc-CVTZ.basis
}

{rhf
wf,nelec=ne,spin=2,sym=2
occ,A1,B1,B2,A2
closed,A1-1,B1-1,B2,A2
}

scf=energy

_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy

BE = ccsd - PdE - OE

table,scf,ccsd,BE
save
type,csv
