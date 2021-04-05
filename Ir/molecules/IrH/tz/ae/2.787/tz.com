***,Calculation for PdH groundstate
memory,512,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

basis={
include,tz.basis
include,H-aug-cc-pVTZ.basis
}

ne = 78

A1=19
B1=9
B2=9
A2=4

do i=1,1
z(i) = 2.787 - 0.1*(i-1)
geometry={
	2
	IrH
	Ir 0.0 0.0 0.0
	H 0.0 0.0 z(i)
}
{rks,pbe0
wf,nele=ne,spin=4,sym=1
        occ,A1,B1,B2,A2
        closed,A1-1,B1-1,B2-1,A2-1
}
pbe(i)=energy
{rhf
wf,nelec=ne,spin=4,sym=1
        occ,A1,B1,B2,A2
        closed,A1-1,B1-1,B2-1,A2-1
}
scf(i)=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd(i)=energy
enddo

table,z,pbe,scf
save
type,csv

