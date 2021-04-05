***, Calculation for Ir groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
!symmetry,nosym

set,dkroll=1,dkho=10,dkhp=4


geometry={
	1
	Iridium
	Ir 0.0 0.0 0.0
}



basis={
include,Ir-cc-pVTZ-DK.basis
}
{rhf
 start,atden
 print,orbitals=2
 wf,77,1,3
 occ,12,6,6,3,6,3,3,1
 closed,12,6,6,2,6,2,2,1
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 orbital,4202.2
}
pop
basis={
include,tz.basis
}
{multi
 start,4202.2
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 wf,77,1,3;state,1
 wf,77,4,3;state,3
 wf,77,6,3;state,3
 wf,77,7,3;state,3
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=60
 start,5202.2
 wf,77,1,3
 occ,12,6,6,3,6,3,3,1
 closed,12,6,6,2,6,2,2,1
}

scf(i)=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,8,5,5,2,5,2,2,1}
ccsd(i)=energy


table,scf,ccsd
save
type,csv
