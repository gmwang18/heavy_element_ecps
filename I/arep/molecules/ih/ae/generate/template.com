***,Calculation for all-electron IH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/I-aug-cc-pwCVXZ.basis
include,../generate/H-aug-cc-pVXZ.basis
}

geometry={
    1
    I atom
    I 0.0 0.0 0.0
}
{rhf;
 start,atden
 print,orbitals=2
 wf,53,5,1
 occ,9,4,4,2,4,2,2,0
 closed,9,4,4,2,3,2,2,0
}
I_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
I_ccsd=energy


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
ne = 54
symm = 1
ss= 0

!There are irrep cards paramters
A1=13
B1=6
B2=6
A2=2


geometry={
    2
    IH molecule
    I 0.0 0.0 0.0
    H 0.0 0.0 length
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
bind=ccsd-I_ccsd-H_ccsd


table,length,scf,ccsd,bind
save
type,csv

