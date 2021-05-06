***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP, ag, 28, 3 ;
1; !  ul potential
1,9.0169600,-8.4466900;
3; !  s-ul potential
0,1.5174000,6.2063400;
2,3.2308800,-56.8262400;
2,4.8274700,92.4017300;
3; !  p-ul potential
0,1.2169900,3.7563700;
2,3.1861500,-80.9533500;
2,4.0534900,118.8680100;
2; !  d-ul potential
0,22.9402000,3.4089500;
2,6.2662700,57.1051300;
include,../generate/Ag-aug-cc-pCVTZ.basis
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
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCVTZ.basis
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
ECP, ag, 28, 3 ;
1; !  ul potential
1,9.0169600,-8.4466900;
3; !  s-ul potential
0,1.5174000,6.2063400;
2,3.2308800,-56.8262400;
2,4.8274700,92.4017300;
3; !  p-ul potential
0,1.2169900,3.7563700;
2,3.1861500,-80.9533500;
2,4.0534900,118.8680100;
2; !  d-ul potential
0,22.9402000,3.4089500;
2,6.2662700,57.1051300;
include,../generate/Ag-aug-cc-pCVTZ.basis
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCVTZ.basis
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
    O 0.0 0.0 1.70
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


table,1.70,scf,ccsd,bind
save
type,csv

