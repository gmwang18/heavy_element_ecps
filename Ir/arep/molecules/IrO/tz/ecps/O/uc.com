***, Calculation for O groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
!symmetry,nosym

set,dkroll=1,dkho=10,dkhp=4

basis={
!include,O-ccECP

include,O-aug-cc-CVTZ.basis 
}

geometry={
	1
	Oxygen
	O 0.0 0.0 0.0
}

ne=8

{rhf
 start,atden
 print,orbitals=2
 wf,ne,7,2
 occ,2,1,1,0,1,0,0,0
 closed,2,1,0,0,0,0,0,0
 sym,1,1,1
 orbital,4202.2
}


scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,1,0,0,0,0,0,0,0}
ccsd=energy


table,scf,ccsd
save
type,csv
