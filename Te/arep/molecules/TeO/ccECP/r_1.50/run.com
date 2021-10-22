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
include,O.aug-cc-pCVQZ-DK.unc.mpro
}

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
ne = 14
symm = 4
ss= 2

!There are irrep cards paramters
A1=4
B1=2
B2=2
A2=0

basis={
include,pp.molpro
include,Te.aug-cc-pwcvqz-dk3.1.unc.mod.mpro

include,O.aug-cc-pCVQZ-DK.unc.mpro
}

geometry={
    2
    TeO molecule
    Te 0.0 0.0 0.0
    O 0.0 0.0 1.50
}
!{rhf,nitord=20;
! maxit,200;
! wf,ne+1,1,ss-1
! occ,A1,B1,B2,A2
! closed,A1,B1,B2,A2
! print,orbitals=2
!}
!{mcscf
! start,4202.2
! occ,A1,B1,B2,A2
! closed,A1,B1,B2-1,A2
! wf,ne,symm,ss
! natorb,ci,print
! orbital,5202.2
!}
{rhf
 wf,ne,symm,ss
 start,5202.2
! occ,A1,B1,B2,A2
! closed,A1,B1-1,B2-1,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-I_ccsd-O_ccsd


table,1.50,scf,ccsd,bind
save
type,csv
