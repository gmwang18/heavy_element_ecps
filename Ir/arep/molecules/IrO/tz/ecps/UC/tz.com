***,Calculation for PdH groundstate
memory,512,m
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
        {rhf
	start,2101.2
        wf,nelec=ne,spin=1,sym=4
        occ,A1,B1,B2,A2
        closed,A1,B1,B2,A2-1
	orbital,3101.2
        print,orbitals=2
        }
        {rhf,nitord=1,maxit=0;
	start,3101.2
        wf,nelec=ne,spin=1,sym=4
        occ,A1,B1,B2,A2
        closed,A1,B1,B2,A2-1
	rotate,13.1,15.1,0
        print,orbitals=2
        }
        scf(i)=energy
        _CC_NORM_MAX=2.0
        {rccsd(t);maxit,100;core,A1-6,B1-2,B2-3,A2-1}
        ccsd(i)=energy
enddo


table,z,scf,ccsd
save
type,csv

