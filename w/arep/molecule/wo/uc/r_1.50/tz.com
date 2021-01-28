***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-12


set,dkroll=1,dkho=10,dkhp=4

basis={
include,../generate/W-contracted.basis
include,../generate/O-contracted.basis
}


!These are the wf cards parameters
ne = 82
symm = 1
ss= 2

!There are irrep cards paramters
A1=20
B1=9
B2=9
A2=4


geometry={
    2
    WO molecule
    W 0.0 0.0 0.0
    O 0.0 0.0 1.50
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1,B2,A2
 orbital,2101.2
}


basis={
include,../generate/W-aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}


{rhf,nitord=20;
 start,2101.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1,B2,A2
 orbital,3202.2
 print,orbitals=2
}

{rhf,nitord=1,maxit=0;
 start,3202.2
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1,B2,A2
 rotate,13.1,15.1,0
 rotate,14.1,16.1,0
 rotate,6.2,8.2,0
 rotate,6.3,8.3,0
 print,orbitals=2
}


scf=energy


_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,14,7,7,3}
ccsd=energy

!
!basis={
!include,../generate/W-contracted.basis
!}
!
!
!
!geometry={
!    1
!    W atom
!    W 0.0 0.0 0.0
!}
!{rhf;
! start,atden;
! orbital,3101.2;
! wf,74,1,4;
! occ,11,6,6,3,6,3,3,1;
! closed,10,6,6,2,6,2,2,1;
! sym,1,1,1,1,1,3,2,1,3,2,1,3,2
!}
!
!
!basis={
!include,../generate/W-aug-cc-pwCVTZ.basis
!}
!
!{rhf;
! start,3101.2;
! print,orbitals=2;
! wf,74,1,4;
! occ,11,6,6,3,6,3,3,1;
! closed,10,6,6,2,6,2,2,1;
! sym,1,1,1,1,1,3,2,1,3,2,1,3,2
!}


!W_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core,8,5,5,2,5,2,2,1}
!W_ccsd=energy
!
!
!basis={
!include,../generate/O-aug-cc-pwCVTZ.basis
!}
!
!
!geometry={
!   1
!   Oxygen
!   O 0.0 0.0 0.0
!}
!{rhf;
! start,atden
! wf,8,7,2;
! occ,2,1,1,0,1,0,0,0;
! closed,2,1,0,0,0,0,0,0;
!}
!O_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,100;core,1,0,0,0,0,0,0,0}
!O_ccsd=energy
!



table,1.50,scf,ccsd !,W_scf,W_ccsd,O_scf,O_ccsd
save
type,csv

