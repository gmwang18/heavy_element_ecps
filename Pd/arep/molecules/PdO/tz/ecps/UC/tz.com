***,Calculation for PdH groundstate
memory,512,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

basis={
include,Pd-aug-cc-pwCVTZ.basis
include,H-aug-cc-pVTZ.basis
}

ne = 47

A1=12
B1=5
B2=5
A2=2

!A1=5
!B1=2
!B2=2
!A2=1


do i=1,11
        if(i.eq.1) then
                z(i) = 1.179
        else if(i.eq.2) then
                z(i) = 1.229
        else if(i.eq.3) then
                z(i) = 1.279
        else if(i.eq.4) then
                z(i) = 1.329
        else if(i.eq.5) then
                z(i) = 1.379
        else if(i.eq.6) then
                z(i) = 1.429
        else if(i.eq.7) then
                z(i) = 1.479
        else if(i.eq.8) then
                z(i) = 1.529
        else if(i.eq.9) then
                z(i) = 1.579
        else if(i.eq.10) then
                z(i) = 1.629
        else if(i.eq.11) then
                z(i) = 1.679
        endif

        geometry={
                2
                PdH
                Pd 0.0 0.0 0.0
                H 0.0 0.0 z(i)
        }
	{rhf
	wf,nelec=ne,spin=1,sym=1
	occ,A1,B1,B2,A2
	closed,A1-1,B1,B2,A2
	}
	scf(i)=energy
	_CC_NORM_MAX=2.0
	{rccsd(t);maxit,100;core,7,3,3,1}
	ccsd(i)=energy
	
enddo



table,z,scf,ccsd
save
type,csv

