***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4

basis={
include,../generate/W-contracted.basis
include,../generate/H-contracted.basis
}

!These are the wf cards parameters
ne = 75
symm = 1
ss= 5

!There are irrep cards paramters
A1=18
B1=9
B2=9
A2=4


geometry={
    2
    WH molecule
    W 0.0 0.0 0.0
    H 0.0 0.0 length
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 orbital,2101.2
}


basis={
include,../generate/W-aug-cc-pwCVTZ.basis
include,../generate/H-aug-cc-pVTZ.basis
}

{rhf,nitord=20;
 start,2101.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}


scf=energy

_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy


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
! wf,74,1,4;
! occ,11,6,6,3,6,3,3,1;
! closed,10,6,6,2,6,2,2,1;
! sym,1,1,1,1,1,3,2,1,3,2,1,3,2
! orbital,3202.2
!}
!
!basis={
!include,../generate/W-aug-cc-pwCVTZ.basis
!}
!
!{multi
! start,3202.2
! occ,12,6,6,3,6,3,3,1
! closed,10,6,6,2,6,2,2,1
! wf,74,1,4;state,2
! wf,74,4,4;state,1
! wf,74,6,4;state,1
! wf,74,7,4;state,1
! natorb,ci,print
! orbital,4202.2
!}
!
!{rhf,nitord=1,maxdis=30,iptyp='DIIS',maxit=100; shift,-1.5,-1.0;
! start,4202.2;
! print,orbitals=2;
! wf,74,1,4;
! occ,11,6,6,3,6,3,3,1;
! closed,10,6,6,2,6,2,2,1;
!}
!
!W_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
!W_ccsd=energy
!
!
!basis={
!include,../generate/H-aug-cc-pVTZ.basis
!}
!
!
!geometry={
!   1
!   Hydrogen
!   H 0.0 0.0 0.0
!}
!{rhf;
! start,atden
! wf,1,1,1;
! occ,1,0,0,0,0,0,0,0;
! open,1.1;
!}
!H_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,100;core}
!H_ccsd=energy





table,length,scf,ccsd !,W_scf,W_ccsd,H_scf,H_ccsd
save
type,csv

