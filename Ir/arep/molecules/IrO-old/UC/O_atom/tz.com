***,Calculation for IrO groundstate

memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

geometry={
   1
   O
   O 0.0 0.0 0.0
}

basis={
!include,O.pp
include,O-aug-cc-CVTZ.basis
}

{rhf
 wf,8,7,2;
 occ,2,1,1,0,1,0,0,0;
 closed,2,1,0,0,0,0,0,0;
}

B_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,1,0,0,0,0,0,0,0}
B_ccsd=energy

table,z,scf,ccsd,A_scf,A_ccsd,B_scf,B_ccsd
save, 3.csv, new
