***,Calculation for IrH groundstate
memory,512,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
                                                                                !symmetry,nosym

basis={
include,tn-df

include,tz.basis

ecp,H,0,1,0
3
1, 21.24359508259891,   1.00000000000000
3, 21.24359508259891,  21.24359508259891
2, 21.77696655044365, -10.85192405303825
1
2, 1.000000000000000,   0.00000000000000

include,H-aug-cc-pVTZ.basis
}

ne = 18

A1=5
B1=2
B2=2
A2=1

do i=1,1
        if(i.eq.1) then
                z(i) = 1.400
        else if(i.eq.2) then
                z(i) = 1.500
        else if(i.eq.3) then
                z(i) = 1.600
        else if(i.eq.4) then
                z(i) = 1.700
        else if(i.eq.5) then
                z(i) = 1.800
        endif

	geometry={
		2
		IrH
		Ir 0.0 0.0 0.0
		H 0.0 0.0 z(i)
	}
	{rhf,maxdis=45,iptyp='DIIS',nitord=30,maxit=60; shift,-2.0,-1.0
        wf,nelec=ne,spin=2,sym=4
	occ,A1,B1,B2,A2
	closed,A1-1,B1,B2,A2-1
        print,orbitals=2
	}
	scf(i)=energy
	!_CC_NORM_MAX=2.0
        !{rccsd(t);maxit,100;core}
        !ccsd(i)=energy
enddo

table,z,scf!,ccsd
save
type,csv

