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
 open,4.1
 sym,1,1,3,2,1
}
Ag_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
Ag_ccsd=energy



basis={
ecp,O,2,1,0
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCV5Z.basis
}


geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,6,7,2;
 occ,1,1,1,0,1,0,0,0;
 open,1.3,1.5
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy



basis={
ecp,Ag,28,3,0;
4;1, 11.1000000, 19.0000000; 3, 11.1000000, 210.900000; 2, 11.019898, -111.290000; 2, 5.5000000, -10.0000000;
2;2, 12.45703546, 281.02799919; 2, 7.10388574, 40.39630556;
2;2, 11.07473684, 211.24826673; 2, 6.8864247, 30.95726264;
2;2, 10.5531548, 101.12265229; 2, 4.55056604, 14.55491325;
include,../generate/Ag-aug-cc-pCV5Z.basis
ecp,O,2,1,0
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCV5Z.basis
}


!These are the wf cards parameters
ne = 25
symm = 3
ss= 1

!There are irrep cards paramters
A1=6
B1=3
B2=3
A2=1


geometry={
    2
    AgO molecule
    Ag 0.0 0.0 0.0
    O 0.0 0.0 2.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2-1,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ag_ccsd-O_ccsd


table,2.20,scf,ccsd,bind
save
type,csv

