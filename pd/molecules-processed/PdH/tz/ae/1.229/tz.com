***, Calculation for PdH groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

set,dkroll=1,dkho=10,dkhp=4

basis={

include,c-Pd-aug-cc-pwCVTZ.basis

include,c-H-aug-cc-pVTZ.basis
}

ne = 47

geometry={
	2
	PdH
	Pd 0.0 0.0 0.0
	H 0.0 0.0 1.229
}

A1=12
B1=5
B2=5
A2=2

{rks,pbe0
wf,nele=ne,spin=1,sym=1
occ,A1,B1,B2,A2
closed,A1-1,B1,B2,A2
}
{rhf
wf,nelec=ne,spin=1,sym=1
occ,A1,B1,B2,A2
closed,A1-1,B1,B2,A2
}


basis={

include,Pd-aug-cc-pwCVTZ.basis

include,H-aug-cc-pVTZ.basis
}

{rhf
wf,nelec=ne,spin=1,sym=1
occ,A1,B1,B2,A2
closed,A1-1,B1,B2,A2
}

E_Pd = -5044.366379
E_H = -0.49982785

scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
BE = ccsd - E_Pd - E_H

table,scf,ccsd,BE

save
type,csv
