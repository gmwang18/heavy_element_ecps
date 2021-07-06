***,Calculation for IrH groundstate
memory,1024,m

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
                                                                                !symmetry,nosym
basis={
include,Pd.pp
include,aug-cc-pwCVTZ.basis

include,O.pp
include,O_aug-cc-CVTZ.basis
}

ne = 24

A1=6
B1=3
B2=3
A2=1


do i=2,2
        z(i) = 1.985 - 0.05*(i-1)
        geometry={
                2
                PdO
                Pd 0.0 0.0 0.0 
                O 0.0 0.0 z(i)
        }
        {rhf
        wf,nelec=ne,spin=2,sym=2
        occ,A1,B1,B2,A2
        closed,A1-1,B1-1,B2,A2
        }

        scf(i)=energy
        _CC_NORM_MAX=2.0
        {rccsd(t);maxit,100;core}
        ccsd(i)=energy

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
! wf,18,1,0
! occ,4,1,1,1,1,1,1,0
! closed,4,1,1,1,1,1,1,0
! sym,1,1,3,2,1
! orbital,4202.2
!}
!pop
!{multi
! start,4202.2
! maxit,40
! occ,4,1,1,1,1,1,1,0
! closed,4,1,1,1,1,1,1,0
! wf,18,1,0;state,1
! natorb,ci,print
! orbital,4203.2
!}
!{rhf,nitord=1,maxit=100
! start,4203.2
! wf,18,1,0
! occ,4,1,1,1,1,1,1,0
! closed,4,1,1,1,1,1,1,0
! sym,1,1,3,2,1
!}
!A_scf=energy
!_CC_NORM_MAX=2.0
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
!include,O_aug-cc-CVTZ.basis
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

