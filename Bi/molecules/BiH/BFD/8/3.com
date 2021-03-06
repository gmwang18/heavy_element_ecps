***,Calculation of binding energy
memory,512,m

gthresh,oneint=1.0E-15
gthresh,twoint=1.0E-15

!set,dkroll=1,dkho=10,dkhp=4

ne    =6
symm  =4
ss    =2

A1=2
B1=1 
B2=1
A2=0

do i=8,8
	z(i) = 1.3 + 0.10*(i-1)
	geometry={
	    2
	    BiH
	    Bi 0.0 0.0 0.0
	    H  0.0 0.0 z(i)
	}
	
	basis={
	include,Bi.pp
	include,Bi_contr_TZ.basis
	include,H.pp
	include,H_contr_TZ.basis
	}
	{rhf
	 wf,nelec=ne,spin=ss,sym=symm
	 occ,A1,B1,B2,A2
	 closed,A1,B1-1,B2-1,A2
	 !orbital,2101.2
	}
	
	basis={
	include,Bi.pp
	include,Bi_aug-cc-pwCVTZ.basis
	include,H.pp
	include,H_aug-cc-pVTZ.basis
	}
	{rhf,maxdis=20,iptyp='DIIS',nitord=1,maxit=60; shift,-1.0,-0.5
	 wf,nelec=ne,spin=ss,sym=symm
	 occ,A1,B1,B2,A2
	 closed,A1,B1-1,B2-1,A2
	 !orbital,ignore_error
	}
	scf(i)=energy
	
	_CC_NORM_MAX=2.0
	{rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core
	!orbital,ignore_error
	}
	ccsd(i)=energy
enddo

!geometry={
!1
!Bi
!Bi 0.0 0.0 0.0
!}
!
!{rhf
! start,atden
! print,orbitals=1
! wf,5,8,3
! occ,1,1,1,0,1,0,0,0
! closed,1,0,0,0,0,0,0,0
! orbital,4202.2
!}
!pop
!{multi
! start,4202.2
! occ,1,1,1,0,1,0,0,0
! closed,1,0,0,0,0,0,0,0
! wf,5,8,3;state,1
! natorb,ci,print
! orbital,5202.2
!}
!{rhf,nitord=1,maxit=0
! start,5202.2
! wf,5,8,3
! occ,1,1,1,0,1,0,0,0
! closed,1,0,0,0,0,0,0,0
!}
!
!A_scf=energy
!_CC_NORM_MAX=2.0
!{rccsd(t),shifts=0.3,shiftp=0.3,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
!A_ccsd=energy
!
!
!
!geometry={
!   1
!   H
!   H 0.0 0.0 0.0
!}
!
!basis={
!include,H.pp
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

