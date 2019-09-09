***,Calculation for all-electron SrO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/Sr-aug-cc-pwCVQZ.basis
include,../generate/O-aug-cc-pCVQZ.basis
}

geometry={
    1
    Sr atom
    Sr 0.0 0.0 0.0
}
{rhf;
 start,atden;
 print,orbitals=2;
 wf,38,1,0;
 occ,7,3,3,1,3,1,1,0;
 closed,7,3,3,1,3,1,1,0;
 sym,1,1,1,1,1,3,2,1
}
Sr_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
Sr_ccsd=energy


geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,8,7,2;
 occ,2,1,1,0,1,0,0,0;
 open,1.3,1.5;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy


!These are the wf cards parameters
ne = 46
symm = 1
ss= 0

!There are irrep cards paramters
A1=12
B1=5
B2=5
A2=1


geometry={
    2
    SrO molecule
    Sr 0.0 0.0 0.0
    O 0.0 0.0 2.05
}
{rhf,nitord=20;
 maxit,200;
 start,4202.2
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
 orbital,4202.2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Sr_ccsd-O_ccsd


table,2.05,scf,ccsd,bind
save
type,csv

