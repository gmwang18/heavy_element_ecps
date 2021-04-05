***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,O-aug-cc-CVTZ.basis
}

A1=6
B1=3
B2=3
A2=1

ne = 6


geometry={
        1
        O
        O 0.0 0.0 0.0
}
{rhf
start,atden
print,orbitals=2
wf,nelec=ne,spin=2,sym=7
occ,1,1,1,0,1,0,0,0
closed,1,1,0,0,0,0,0,0
}

scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy


table,scf,ccsd
save
type,csv
