***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/I-aug-cc-pwCVQZ.basis
include,../generate/O-aug-cc-pCVQZ.basis
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
{rccsd(t);maxit,200;core,8,3,3,2,3,2,2,0}
I_ccsd=energy


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
{rccsd(t);maxit,100;core,1,0,0,0,0,0,0,0}
O_ccsd=energy


!These are the wf cards parameters
ne = 61
symm = 3
ss= 1

!There are irrep cards paramters
A1=15
B1=7
B2=7
A2=2


geometry={
    2
    IO molecule
    I 0.0 0.0 0.0
    O 0.0 0.0 2.30
}
{rhf,nitord=20;
 maxit,200;
 wf,ne+1,1,ss-1
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
{mcscf
 start,4202.2
 occ,A1,B1,B2,A2
 closed,A1,B1,B2-1,A2
 wf,ne,symm,ss
 natorb,ci,print
 orbital,5202.2
}
{rhf
 wf,ne,symm,ss
 start,5202.2
 occ,A1,B1,B2,A2
 closed,A1,B1,B2-1,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,12,5,5,2}
ccsd=energy
bind=ccsd-I_ccsd-O_ccsd


table,2.30,scf,ccsd,bind
save
type,csv

