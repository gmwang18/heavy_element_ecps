***, Calculation for PtH groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
!symmetry,nosym

set,dkroll=1,dkho=10,dkhp=4

basis={

include,O-contracted.basis

include,Pt-contracted.basis
}

ne = 86
z = 1.6

geometry={
	2
	PtH
	Pt 0.0 0.0 0.0
	O 0.0 0.0 z
}

A1=20
B1=10
B2=9
A2=4

basis={

include,Pt-aug-cc-pwCVTZ.basis

include,O-aug-cc-pCVTZ.basis
}

{rhf
wf,nelec=ne,spin=0,sym=1
occ,A1,B1,B2,A2
closed,A1,B1,B2,A2
orbital,2101.2
}

{rhf,nitord=1,maxit=0;
start,2101.2
wf,nelec=ne,spin=0,sym=1
occ,A1,B1,B2,A2
closed,A1,B1,B2,A2
rotate,13.1,15.1,0
orbital,3101.2
}

scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,14,7,7,3}
ccsd=energy

table,z,scf,ccsd
save, 3.csv, new

