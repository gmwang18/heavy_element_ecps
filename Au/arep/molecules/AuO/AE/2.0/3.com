***,Calculation of binding energy
memory,1,g
gthresh,twoint=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

ne    =87
symm  =2
ss    =1

A1=20
B1=10
B2=10
A2=4

! Equilibrium geometry
geometry={
    2
    AuO
    Au 0.0 0.0 0.0
    O  0.0 0.0 1.9
}

basis={
!include,Au.pp
include,Au_contracted.basis
!include,O.pp
include,O_contracted.basis
}

{rhf
 wf,nelec=ne,spin=ss,sym=symm
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 orbital,2101.2
}

do i=1,1
    z(i) = 2.0 + 0.10*(i-1)
    geometry={
        2
        AuO
        Au  0.0 0.0 0.0
        O  0.0 0.0 z(i)
    }
    {rhf,nitord=1
     start,2101.2
     wf,nelec=ne,spin=ss,sym=symm
     occ,A1,B1,B2,A2
     closed,A1,B1-1,B2,A2
    }
    basis={
    !include,Au.pp
    include,Au_aug-cc-pwCVTZ.basis
    !include,O.pp
    include,O_aug-cc-pwCVTZ.basis
    }
    {rhf,maxdis=30,iptyp='DIIS',nitord=1,maxit=60; shift,-1.5,-1.0
     wf,nelec=ne,spin=ss,sym=symm
     occ,A1,B1,B2,A2
     closed,A1,B1-1,B2,A2
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
!   O
!   O 0.0 0.0 0.0
!}
!
!basis={
!!include,O.pp
!include,O_aug-cc-pwCVTZ.basis
!}
!
!{rhf
! wf,8,7,2;
! occ,2,1,1,0,1,0,0,0;
! closed,2,1,0,0,0,0,0,0;
!}
!
!B_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,100;core}
!B_ccsd=energy

table,z,scf,ccsd !,A_scf,A_ccsd,B_scf,B_ccsd
save, 3.csv, new

