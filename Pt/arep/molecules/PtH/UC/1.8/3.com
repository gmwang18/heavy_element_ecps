***, Calculation for PtH groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
!symmetry,nosym

set,dkroll=1,dkho=10,dkhp=4

ne = 79
z = 1.8

geometry={
	2
	PtH
	Pt 0.0 0.0 0.0
	H 0.0 0.0 z
}

A1=18
B1=9
B2=9
A2=4

basis={

include,Pt-aug-cc-pwCVTZ.basis

include,H-aug-cc-pVTZ.basis
}

{rhf
wf,nelec=ne,spin=1,sym=4
occ,A1,B1,B2,A2
closed,A1,B1,B2,A2-1
orbital,2101.2
}
{rhf,nitord=1,maxit=0
start,2101.2
wf,nelec=ne,spin=1,sym=4
occ,A1,B1,B2,A2
closed,A1,B1,B2,A2-1
rotate,12.1,14.1,0
orbital,3101.2
}


scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,13,7,7,3}
ccsd=energy

table,z,scf,ccsd
save, 3.csv, new

