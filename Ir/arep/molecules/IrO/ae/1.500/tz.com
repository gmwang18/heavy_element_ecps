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
B1=10
B2=10
A2=4

do i=1,1
	z(i) = 1.500 - 0.1*(i-1)
	geometry={
		2
		IrO
		Ir 0.0 0.0 0.0
		O 0.0 0.0 z(i)
	}
        {rhf
        wf,nelec=ne-3,spin=0,sym=1
                occ,A1,B1-1,B2-1,A2-1
                closed,A1,B1-1,B2-1,A2-1
        print,orbitals=2
        }
        {rhf,nitord=20
        wf,nelec=ne,spin=3,sym=1
                occ,A1,B1,B2,A2
                closed,A1,B1-1,B2-1,A2-1
        print,orbitals=2
        }
        scf(i)=energy
        _CC_NORM_MAX=2.0
        {rccsd(t);maxit,100;core}
        ccsd(i)=energy
enddo

table,z,scf,ccsd
save
type,csv

