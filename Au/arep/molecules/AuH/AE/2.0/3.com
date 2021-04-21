***,Calculation of binding energy
memory,512,m
gthresh,twoint=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

ne    =80
symm  =1
ss    =0

A1=18
B1=9
B2=9
A2=4

! Equilibrium geometry
geometry={
    2
    AuH
    Au 0.0 0.0 0.0
    H  0.0 0.0 1.6
}

basis={
!include,Au.pp
include,Au_contracted.basis
!include,H.pp
include,H_contracted.basis
}

{rhf
 wf,nelec=ne,spin=ss,sym=symm
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 orbital,2101.2
}

do i=1,1
    z(i) = 2.0 + 0.10*(i-1)
    geometry={
        2
        AuH
        Au  0.0 0.0 0.0
        H  0.0 0.0 z(i)
    }
    {rhf,nitord=1
     start,2101.2
     wf,nelec=ne,spin=ss,sym=symm
     occ,A1,B1,B2,A2
     closed,A1,B1,B2,A2
    }
    basis={
    !include,Au.pp
    include,Au_aug-cc-pwCVTZ.basis
    !include,H.pp
    include,H_aug-cc-pVTZ.basis
    }
    {rhf,maxdis=30,iptyp='DIIS',nitord=1,maxit=60; shift,-1.5,-1.0
     wf,nelec=ne,spin=ss,sym=symm
     occ,A1,B1,B2,A2
     closed,A1,B1,B2,A2
     orbital,ignore_error
    }
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t);maxit,100;core
     orbital,ignore_error
    }
    ccsd(i)=energy
enddo

!geometry={
!   1
!   Au
!   Au 0.0 0.0 0.0
!}
!
!basis={
!include,Au_contracted.basis
!}
!{rhf
! start,atden
! print,orbitals=2
! wf,79,1,1
! occ,12,6,6,3,6,3,3,1
! open,12.1
! sym,1,1,1,1,1,3,2,3,2,1,3,2,1
! orbital,4202.2
!}
!pop
!basis={
!include,Au_aug-cc-pwCVTZ.basis
!}
!{multi
! start,4202.2
! occ,12,6,6,3,6,3,3,1
! closed,11,6,6,3,6,3,3,1
! wf,79,1,1;state,1
! restrict,1,1,12.1
! natorb,ci,print
! orbital,5202.2
!}
!{rhf,nitord=1,maxit=0
! start,5202.2
! wf,79,1,1
! occ,12,6,6,3,6,3,3,1
! open,12.1
!}
!
!A_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,100;core}
!A_ccsd=energy
!
!geometry={
!   1
!   H
!   H 0.0 0.0 0.0
!}
!
!basis={
!!include,H.pp
!include,H_aug-cc-pVTZ.basis
!}
!
!{rhf;
! start,atden
! wf,1,1,1;
! occ,1,0,0,0,0,0,0,0;
! open,1.1;
!}
!
!B_scf=energy
!_CC_NORM_MAX=2.0
!!{rccsd(t);maxit,100;core}
!B_ccsd=energy

table,z,scf,ccsd ,A_scf,A_ccsd,B_scf,B_ccsd
save, 3.csv, new

