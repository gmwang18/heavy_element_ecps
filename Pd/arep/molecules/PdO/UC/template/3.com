***,Calculation for IrH groundstate
memory,1024,m

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
                                                                                !symmetry,nosym
set,dkroll=1,dkho=10,dkhp=4

basis={
include,c-Pd-aug-cc-pwCVTZ.basis
include,c-O-aug-cc-CVTZ.basis
}

ne = 54

A1=14
B1=6
B2=6
A2=2



do i=index,index
        z(i) = 1.985 - 0.05*(i-1)
        geometry={
                2
                PdO
                Pd 0.0 0.0 0.0 
                O 0.0 0.0 z(i)
        }
	{rks,pbe0
	wf,nele=ne,spin=2,sym=2
	occ,A1,B1,B2,A2
	closed,A1-1,B1-1,B2,A2
	}
	{rhf
	wf,nelec=ne,spin=2,sym=2
	occ,A1,B1,B2,A2
	closed,A1-1,B1-1,B2,A2
	}
	basis={
	include,aug-cc-pwCVTZ.basis
	include,O_aug-cc-CVTZ.basis
	}
	{rhf
	wf,nelec=ne,spin=2,sym=2
	occ,A1,B1,B2,A2
	closed,A1-1,B1-1,B2,A2
	}
	scf=energy
	
	_CC_NORM_MAX=2.0
	{rccsd(t);maxit,100;core,8,3,3,1}
	ccsd=energy

enddo

!geometry={
!	1
!	Palladium
!	Pd 0.0 0.0 0.0
!}
!
!{rhf,maxdis=50,iptyp='DIIS',nitord=30,maxit=60; shift,-2.0,-1.0
! start,atden
! print,orbitals=2
!}
!{rhf
! start,atden
! print,orbitals=2
! wf,46,1,0
! occ,8,3,3,2,3,2,2,0
! closed,8,3,3,2,3,2,2,0
! sym,1,1,1,1,3,2,1,3,2
! orbital,4202.2
!}
!pop
!{multi
! start,4202.2
! maxit,40
! occ,8,3,3,2,3,2,2,0
! closed,8,3,3,2,3,2,2,0
! wf,46,1,0;state,1
! natorb,ci,print
! orbital,4203.2
!}
!{rhf,nitord=1,maxit=100
! start,4203.2
! wf,46,1,0
! occ,8,3,3,2,3,2,2,0
! closed,8,3,3,2,3,2,2,0
! sym,1,1,1,1,3,2,1,3,2
!}
!A_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t),shifts=0.3,shiftp=0.3,thrdis=1.0;diis,1,1,15,1;maxit,100;core,5,2,2,1,2,1,1,0}
!A_ccsd=energy  
!
!geometry={
!   1
!   O
!   O 0.0 0.0 0.0
!}
!
!basis={
!include,O_aug-cc-CVTZ.basis
!}
!
!{rhf;
! start,atden
! wf,8,7,2;
! occ,2,1,1,0,1,0,0,0;
! open,1.3,1.5;
!}
!
!B_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t);maxit,100;core,1,0,0,0,0,0,0,0}
!B_ccsd=energy


table,z,scf,ccsd!, A_scf,A_ccsd,B_scf,B_ccsd
save, 3.csv, new

