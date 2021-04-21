***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4


basis={
include,../generate/W-contracted.basis
}

geometry={
    1
    W atom
    W 0.0 0.0 0.0
}
{rhf;
 start,atden;
 wf,74,1,4;
 occ,11,6,6,3,6,3,3,1;
 closed,10,6,6,2,6,2,2,1;
 sym,1,1,1,1,1,3,2,1,3,2,1,3,2
 orbital,3202.2
}


basis={
include,../generate/W-aug-cc-pwCVTZ.basis
}

{multi
 start,3202.2
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 wf,74,1,4;state,2
 wf,74,4,4;state,1
 wf,74,6,4;state,1
 wf,74,7,4;state,1
 natorb,ci,print
 orbital,5202.2
}

{rhf,nitord=1,maxdis=30,iptyp='DIIS',maxit=100; shift,-1.5,-1.0;
 start,5202.2;
 print,orbitals=2;
 wf,74,1,4;
 occ,11,6,6,3,6,3,3,1;
 closed,10,6,6,2,6,2,2,1;
 orbital,6202.2
}

{rhf,nitord=1,maxit=0;
 start,6202.2;
 print,orbitals=2;
 wf,74,1,4;
 occ,11,6,6,3,6,3,3,1;
 closed,10,6,6,2,6,2,2,1;
 rotate,4.2,6.2,0
 rotate,4.3,6.3,0
 rotate,4.5,6.5,0
}

W_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;core,8,5,5,2,5,2,2,1}
W_ccsd=energy


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
!
!
!
!
!basis={
!include,../generate/W-contracted.basis
!include,../generate/H-contracted.basis
!}
!
!!These are the wf cards parameters
!ne = 75
!symm = 1
!ss= 5
!
!!There are irrep cards paramters
!A1=18
!B1=9
!B2=9
!A2=4
!
!
!geometry={
!    2
!    WH molecule
!    W 0.0 0.0 0.0
!    H 0.0 0.0 1.20
!}
!{rhf,nitord=20;
! start,atden
! maxit,200;
! wf,ne,symm,ss
! occ,A1,B1,B2,A2
! closed,A1-2,B1-1,B2-1,A2-1
! orbital,7202.2
!}
!
!
!basis={
!include,../generate/W-aug-cc-pwCVTZ.basis
!include,../generate/H-aug-cc-pVTZ.basis
!}
!
!{rhf,nitord=20;
! start,7202.2
! maxit,200;
! wf,ne,symm,ss
! occ,A1,B1,B2,A2
! closed,A1-2,B1-1,B2-1,A2-1
! print,orbitals=2
!}
!
!
!scf=energy
!
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,100;core,13,7,7,3}
!ccsd=energy
!
!
!
!table,1.20,scf,ccsd,W_scf,W_ccsd,H_scf,H_ccsd
!save
!type,csv

table,W_scf,W_ccsd
save
type,csv
