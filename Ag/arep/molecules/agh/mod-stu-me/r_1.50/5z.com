***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12


basis={
ecp,Ag,28,3,0;
4;1, 11.1000000, 19.0000000; 3, 11.1000000, 210.900000; 2, 11.019898, -111.290000; 2, 5.5000000, -10.0000000;
2;2, 12.45703546, 281.02799919; 2, 7.10388574, 40.39630556;
2;2, 11.07473684, 211.24826673; 2, 6.8864247, 30.95726264;
2;2, 10.5531548, 101.12265229; 2, 4.55056604, 14.55491325;
include,../generate/Ag-aug-cc-pCV5Z.basis
}


geometry={
    1
    Ag atom
    Ag 0.0 0.0 0.0
}
{rhf;
 start,atden;
 print,orbitals=2;
 wf,19,1,1;
 occ,4,1,1,1,1,1,1,0;
 closed,3,1,1,1,1,1,1,0;
 open,4.1
 sym,1,1,3,2,1
}
Ag_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
Ag_ccsd=energy


basis={
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pV5Z.basis
}


geometry={
   1
   Hydrogen
   H 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,1,1,1;
 occ,1,0,0,0,0,0,0,0;
 open,1.1;
}
H_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
H_ccsd=energy



basis={
ecp,Ag,28,3,0;
4;1, 11.1000000, 19.0000000; 3, 11.1000000, 210.900000; 2, 11.019898, -111.290000; 2, 5.5000000, -10.0000000;
2;2, 12.45703546, 281.02799919; 2, 7.10388574, 40.39630556;
2;2, 11.07473684, 211.24826673; 2, 6.8864247, 30.95726264;
2;2, 10.5531548, 101.12265229; 2, 4.55056604, 14.55491325;
include,../generate/Ag-aug-cc-pCV5Z.basis
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pV5Z.basis
}



!These are the wf cards parameters
ne = 20
symm = 1
ss= 0

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    AgH molecule
    Ag 0.0 0.0 0.0
    H 0.0 0.0 1.50
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ag_ccsd-H_ccsd


table,1.50,scf,ccsd,bind
save
type,csv

