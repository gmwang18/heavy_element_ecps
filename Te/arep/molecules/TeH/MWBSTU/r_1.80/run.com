***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

!set,dkroll=1,dkho=10,dkhp=4
basis={
include,pp.molpro

include,Te.aug-cc-pwcvqz-dk3.1.unc.mod.mpro
}

geometry={
    1
    Te atom
    Te 0.0 0.0 0.0
}
{rhf;
 start,atden
 print,orbitals=2
 wf,6,4,2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,1,0,0,0
}
I_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
I_ccsd=energy

basis={
include,H.aug-cc-pVQZ-DK.mpro
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
 closed,0,0,0,0,0,0,0,0;
}
H_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
H_ccsd=energy


!These are the wf cards parameters
ne = 7
symm = 2
ss= 1

!There are irrep cards paramters
A1=2
B1=1
B2=1
A2=0

basis={
include,pp.molpro
include,Te.aug-cc-pwcvqz-dk3.1.unc.mod.mpro

include,H.aug-cc-pVQZ-DK.mpro
}

geometry={
    2
    TeH molecule
    Te 0.0 0.0 0.0
    H 0.0 0.0 1.80
}
{rhf
 wf,ne,symm,ss
 start,5202.2
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-I_ccsd-H_ccsd


table,1.80,scf,ccsd,bind
save
type,csv

