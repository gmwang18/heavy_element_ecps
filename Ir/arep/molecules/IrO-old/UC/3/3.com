***,Calculation for IrO groundstate
memory,512,m

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

basis={
include,tz.basis
include,O_aug-cc-CVTZ.basis
}

ne = 85

A1=20
B1=9
B2=10
A2=4

do i=3,3
        z(i) = 1.4 + 0.10*(i-1)
        geometry={
                2
                IrO
                Ir 0.0 0.0 0.0
                O 0.0 0.0 z(i)
        }

        {rks,pbe0
        wf,nele=ne,spin=1,sym=4
        occ,A1,B1,B2,A2
        closed,A1,B1,B2,A2-1
        }
        {rhf
        wf,nelec=ne,spin=1,sym=4
        occ,A1,B1,B2,A2
        closed,A1,B1,B2,A2-1
	orbital,3101.2
        }
        {rhf,nitord=1,maxit=0;
	start,3101.2
        wf,nelec=ne,spin=1,sym=4
        occ,A1,B1,B2,A2
        closed,A1,B1,B2,A2-1
	rotate,13.1,15.1,0
        print,orbitals=2
        }
        scf(i)=energy
        _CC_NORM_MAX=2.0
        {rccsd(t);maxit,100;core,A1-6,B1-2,B2-3,A2-1}
        ccsd(i)=energy
enddo
 
!geometry={
!        1
!        Iridium
!        Ir 0.0 0.0 0.0
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
!{rhf,nitord=1,maxit=0
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
!   Oxygen
!   O 0.0 0.0 0.0
!}
!basis={
!include,O_aug-cc-CVTZ.basis
!}
!
!{rhf;
! start,atden
! wf,8,7,2;
! occ,2,1,1,0,1,0,0,0;
! closed,2,1,0,0,0,0,0,0;
!}
!B_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,100;core,1,0,0,0,0,0,0,0}
!B_ccsd=energy

table,z,scf,ccsd!, A_scf,A_ccsd,B_scf,B_ccsd
save, 3.csv, new


