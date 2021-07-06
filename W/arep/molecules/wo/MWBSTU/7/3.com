***,Calculation for IrH groundstate
memory,1024,m

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
                                                                                !symmetry,nosym
basis={
include,W.pp
include,W-aug-cc-pwCVTZ.basis

include,O.pp
include,O-aug-cc-pwCVTZ.basis
}

!These are the wf cards parameters
ne = 20

!There are irrep cards paramters
A1=6
B1=2
B2=2
A2=1

do i=7,7
        z(i) = 1.3 + 0.1*(i-1)
        geometry={
                2
                WO
                W 0.0 0.0 0.0
                O 0.0 0.0 z(i)
        }
        {rhf,nitord=20;
	maxit,200;
        wf,nelec=ne,spin=2,sym=1
        occ,A1,B1,B2,A2
        closed,A1-2,B1,B2,A2
	print,orbitals=2
        }
        scf(i)=energy
        _CC_NORM_MAX=2.0
        {rccsd(t);maxit,100;core}
        ccsd(i)=energy

enddo

!geometry={
!    1
!    W atom
!    W 0.0 0.0 0.0
!}
!{rhf,maxdis=30,iptyp='DIIS',maxit=200; shift,-1.5,-1.0;
! start,atden;
! print,orbitals=2;
! wf,14,1,4
! occ,3,1,1,1,1,1,1,0
! closed,2,1,1,0,1,0,0,0
! sym,1,1,1,3,2
!}
!{rccsd(t),shifts=0.3,shiftp=0.3,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
!A_ccsd=energy  
!
!geometry={
!   1
!   O
!   O 0.0 0.0 0.0
!}
!
!basis={
!include,O.pp
!include,O-aug-cc-pwCVTZ.basis
!}
!
!{rhf;
! start,atden
! wf,6,7,2;
! occ,1,1,1,0,1,0,0,0;
! open,1.3,1.5;
!}
!
!B_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,100;core}
!B_ccsd=energy


table,z,scf,ccsd!, A_scf,A_ccsd,B_scf,B_ccsd
save, 3.csv, new

