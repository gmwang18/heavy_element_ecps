***, Calculation for Ir groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
!symmetry,nosym

!set,dkroll=1,dkho=10,dkhp=4

basis={
include,bk1.8
include,tz.basis 
}

geometry={
	1
	Iridium
	Ir 0.0 0.0 0.0
}

{rhf,maxdis=50,iptyp='DIIS',nitord=30,maxit=60; shift,-2.0,-1.0
 start,atden
 print,orbitals=2
 wf,17,1,3
 occ,4,1,1,1,1,1,1,0
 closed,4,1,1,0,1,0,0,0
 sym,1,1,1,3,2
 orbital,4202.2
}


scf(i)=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd(i)=energy

table,scf,ccsd
save
type,csv
