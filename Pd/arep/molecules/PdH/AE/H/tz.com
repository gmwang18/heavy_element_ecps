***, Calculation for H groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

set,dkroll=1,dkho=10,dkhp=4

basis={
include,H-aug-cc-pVTZ.basis
}

ne = 1

geometry={
	1
	Hydrogen
	H 0.0 0.0 0.0
}
{rhf;
 wf,1,1,1;
 occ,1,0,0,0,0,0,0,0;
 open,1.1;
}

scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy


table,scf,ccsd
save
type,csv
