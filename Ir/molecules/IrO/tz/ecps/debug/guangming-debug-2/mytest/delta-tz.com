***,Calculation for IrO groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
                                                                                !symmetry,nosym

basis={
include,../crenbl

include,../tz.basis

ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406

include,../O-aug-cc-CVTZ.basis
}

ne = 23

A1=6
B1=2
B2=3
A2=1


do i=1,3
        if(i.eq.1) then
                z(i) = 1.500
        else if(i.eq.2) then
                z(i) = 1.600
        else if(i.eq.3) then
                z(i) = 1.700
        else if(i.eq.4) then
                z(i) = 1.800
        else if(i.eq.5) then
                z(i) = 1.900
        endif

	geometry={
		2
		IrO
		Ir 0.0 0.0 0.0
		O 0.0 0.0 z(i)
	}


	{rhf,maxdis=20,iptyp='DIIS',nitord=30,maxit=60; shift,-1.0,-0.5
	wf,nelec=ne,spin=1,sym=4
	occ,A1,B1,B2,A2
	closed,A1,B1,B2,A2-1
	print,orbitals=2
        }
	{rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core}

enddo

table,z,scf!,ccsd
save
type,csv

