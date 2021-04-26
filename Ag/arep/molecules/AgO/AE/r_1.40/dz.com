***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/Ag-aug-cc-pCVDZ.basis
include,../generate/O-aug-cc-pCVDZ.basis
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
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
Ag_ccsd=energy


geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,8,7,2;
 occ,2,1,1,0,1,0,0,0;
 closed,2,1,0,0,0,0,0,0;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy


!These are the wf cards parameters
ne = 55
symm = 3
ss= 1

!There are irrep cards paramters
A1=14
B1=6
B2=6
A2=2


geometry={
    2
    AgO molecule
    Ag 0.0 0.0 0.0
    O 0.0 0.0 1.40
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


table,1.40,scf,ccsd,bind
save
type,csv

