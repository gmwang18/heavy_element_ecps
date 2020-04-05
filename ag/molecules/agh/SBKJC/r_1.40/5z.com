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
    H 0.0 0.0 1.40
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


table,1.40,scf,ccsd,bind
save
type,csv

