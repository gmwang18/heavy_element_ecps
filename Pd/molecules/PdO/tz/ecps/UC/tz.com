***,Calculation for PdH groundstate
memory,512,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

basis={
include,Pd-aug-cc-pwCVTZ.basis
include,O-aug-cc-CVTZ.basis
}

ne = 54

A1=14
B1=6
B2=6
A2=2

!A1=6
!B1=3
!B2=3
!A2=1






do i=1,9
        if(i.eq.1) then
                z(i) = 1.485
        else if(i.eq.2) then
                z(i) = 1.535
        else if(i.eq.3) then
                z(i) = 1.585
        else if(i.eq.4) then
                z(i) = 1.635
        else if(i.eq.5) then
                z(i) = 1.685
        else if(i.eq.6) then
                z(i) = 1.735
        else if(i.eq.7) then
                z(i) = 1.785
        else if(i.eq.8) then
                z(i) = 1.835
        else if(i.eq.9) then
                z(i) = 1.885
        endif

        geometry={
                2
                PdO
                Pd 0.0 0.0 0.0
                O 0.0 0.0 z(i)
        }
	{rhf
	wf,nelec=ne,spin=2,sym=2
	occ,A1,B1,B2,A2
	closed,A1-1,B1-1,B2,A2
	}
	scf(i)=energy
	_CC_NORM_MAX=2.0
	{rccsd(t);maxit,100;core,8,3,3,1}
	ccsd(i)=energy
	
enddo



table,z,scf,ccsd
save
type,csv

