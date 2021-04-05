***,Calculation for IrO groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

basis={
include,tz.basis
include,O-aug-cc-CVTZ.basis
}

ne = 85

A1=20
B1=9
B2=10
A2=4

do i=1,1
	z(i) = 1.900 - 0.1*(i-1)
	geometry={
		2
		IrO
		Ir 0.0 0.0 0.0
		O 0.0 0.0 z(i)
	}
	{rks,pbe0
	wf,nele=ne,spin=1,sym=4
	        occ,A1,B1,B2,A2
	        closed,A1,B1,B2,A2-1
	}
	pbe(i)=energy
	{rhf
	wf,nelec=ne,spin=1,sym=4
	        occ,A1,B1,B2,A2
	        closed,A1,B1,B2,A2-1
	}
	scf(i)=energy
	_CC_NORM_MAX=2.0
	{rccsd(t);maxit,100;core}
	ccsd(i)=energy
enddo

table,z,pbe,scf,ccsd
save
type,csv

