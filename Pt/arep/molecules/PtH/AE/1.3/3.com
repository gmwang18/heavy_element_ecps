***, Calculation for PtH groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
!symmetry,nosym

set,dkroll=1,dkho=10,dkhp=4

basis={

include,H-contracted.basis

include,Pt-contracted.basis
}

ne = 79
z = 1.3

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

{rks,pbe0
wf,nele=ne,spin=1,sym=4
occ,A1,B1,B2,A2
closed,A1,B1,B2,A2-1
}
{rhf
wf,nelec=ne,spin=1,sym=4
occ,A1,B1,B2,A2
closed,A1,B1,B2,A2-1
}


basis={

include,Pt-aug-cc-pwCVTZ.basis

include,H-aug-cc-pVTZ.basis
}

{rhf
wf,nelec=ne,spin=1,sym=4
occ,A1,B1,B2,A2
closed,A1,B1,B2,A2-1
}


scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy

table,z,scf,ccsd
save, 3.csv, new

