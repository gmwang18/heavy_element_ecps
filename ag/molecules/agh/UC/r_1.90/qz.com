***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/Ag-aug-cc-pCVQZ.basis
include,../generate/H-aug-cc-pVQZ.basis
}

geometry={
    1
    Ag atom
    Ag 0.0 0.0 0.0
}
{rhf;
 start,atden;
 print,orbitals=2;
 wf,47,1,1;
 occ,9,3,3,2,3,2,2,0;
 closed,8,3,3,2,3,2,2,0;
 open,9.1
 sym,1,1,1,1,3,2,3,2,1
}
Ag_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core,5,2,2,1,2,1,1,0}
Ag_ccsd=energy


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


!These are the wf cards parameters
ne = 48
symm = 1
ss= 0

!There are irrep cards paramters
A1=12
B1=5
B2=5
A2=2


geometry={
    2
    AgH molecule
    Ag 0.0 0.0 0.0
    H 0.0 0.0 1.90
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
{rccsd(t);maxit,100;core,7,3,3,1}
ccsd=energy
bind=ccsd-Ag_ccsd-H_ccsd


table,1.90,scf,ccsd,bind
save
type,csv

