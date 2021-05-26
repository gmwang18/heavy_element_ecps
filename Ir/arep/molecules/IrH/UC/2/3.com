***,Calculation for IrH groundstate
memory,512,m

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

basis={
include,tz.basis
include,H_aug-cc-pVTZ.basis
}

ne = 78

A1=18
B1=9
B2=9
A2=4

do i=2,2
        z(i) = 1.2 + 0.10*(i-1)
        geometry={
                2
                IrH
                Ir 0.0 0.0 0.0
                H 0.0 0.0 z(i)
        }

        {rks,pbe0
        wf,nele=ne,spin=2,sym=4
        occ,A1,B1,B2,A2
        closed,A1-1,B1,B2,A2-1
        }
        {rhf
        wf,nelec=ne,spin=2,sym=4
        occ,A1,B1,B2,A2
        closed,A1-1,B1,B2,A2-1
	orbital,3101.2
        }
        {rhf,nitord=1,maxit=0;
	start,3101.2
        wf,nelec=ne,spin=2,sym=4
        occ,A1,B1,B2,A2
        closed,A1-1,B1,B2,A2-1
	rotate,12.1,13.1,0
	rotate,13.1,14.1,0
        print,orbitals=2
        }
        scf(i)=energy

        _CC_NORM_MAX=2.0
        {rccsd(t);maxit,100;core,A1-5,B1-2,B2-2,A2-1}
        ccsd(i)=energy
enddo

!geometry={
!	1
!	Iridium
!	Ir 0.0 0.0 0.0
!}
!
!basis={
!include,Ir-cc-pVTZ-DK.basis
!}
!{rhf
! start,atden
! print,orbitals=2
! wf,77,1,3
! occ,12,6,6,3,6,3,3,1
! closed,12,6,6,2,6,2,2,1
! sym,1,1,1,1,3,2,1,3,2,1,1,3,2
! orbital,4202.2
!}
!pop
!basis={
!include,tz.basis
!}
!{multi
! start,4202.2
! occ,12,6,6,3,6,3,3,1
! closed,10,6,6,2,6,2,2,1
! wf,77,1,3;state,1
! wf,77,4,3;state,3
! wf,77,6,3;state,3
! wf,77,7,3;state,3
! natorb,ci,print
! orbital,5202.2
!}
!{rhf,nitord=1,maxit=100
! start,5202.2
! wf,77,1,3
! occ,12,6,6,3,6,3,3,1
! closed,12,6,6,2,6,2,2,1
!}
!A_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,100;core,8,5,5,2,5,2,2,1}
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

table,z,scf,ccsd!, A_scf,A_ccsd,B_scf,B_ccsd
save, 3.csv, new

