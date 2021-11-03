***, Calculation for PtH groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
!symmetry,nosym

set,dkroll=1,dkho=10,dkhp=4


ne = 8

geometry={
	1
	O
	O 0.0 0.0 0.0
}

basis={
include,O-aug-cc-pCVTZ.basis
}

{rhf
wf,nelec=ne,spin=2,sym=7
occ,2,1,1,0,1,0,0,0
closed,2,1,0,0,0,0,0,0
}
pop
{multi
start,4202.2
occ,2,1,1,0,1,0,0,0
closed,2,0,0,0,0,0,0,0
wf,ne,4,2;state,1
wf,ne,6,2;state,1
wf,ne,7,2;state,1
natorb,ci,print
orbital,5202.2
}
{rhf,nitord=1,maxit=0
start,5202.2
wf,ne,7,2
occ,2,1,1,0,1,0,0,0
closed,2,1,0,0,0,0,0,0
}

scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy

table,scf,ccsd
save, 3.csv, new

