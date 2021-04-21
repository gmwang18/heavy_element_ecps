***,Calculation for IrO groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
                                                                                !symmetry,nosym

basis={
include,bk1.6

include,tz.basis

ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406

include,O-aug-cc-CVTZ.basis
}

ne = 23

A1=7
B1=3
B2=3
A2=1


do i=1,3
        if(i.eq.1) then
                z(i) = 1.787
        else if(i.eq.2) then
                z(i) = 1.987
        else if(i.eq.3) then
                z(i) = 2.187
        endif

	geometry={
		2
		IrO
		Ir 0.0 0.0 0.0
		O 0.0 0.0 z(i)
	}
	basis={
	include,bk1.6
	
	include,tz.basis
	
	ecp,O,2,1,0
	3
	1,  12.30997,  6.000000
	3,  14.76962,  73.85984
	2,  13.71419, -47.87600
	1
	2,  13.65512,  85.86406
	
	include,O-aug-cc-CVTZ.basis
	}
        {rks,pbe0
        wf,nele=ne,spin=5,sym=4
        occ,A1,B1,B2,A2
        closed,A1-3,B1-1,B2-1,A2
        }
        {rhf
        wf,nele=ne,spin=5,sym=4
        occ,A1,B1,B2,A2
        closed,A1-3,B1-1,B2-1,A2
        }
	pop
	basis={
	include,lanl2
	
	include,tz.basis
	
	ecp,O,2,1,0
	3
	1,  12.30997,  6.000000
	3,  14.76962,  73.85984
	2,  13.71419, -47.87600
	1
	2,  13.65512,  85.86406
	
	include,O-aug-cc-CVTZ.basis
	}
        !{multi
        !occ,A1,B1,B2,A2
        !frozen,A1-3,B1-1,B2-1,A2
        !wf,nelec=ne,spin=5,sym=4
        !}
        !{multi
        !occ,A1,B1,B2,A2
        !closed,A1-3,B1-1,B2-1,A2
        !wf,nelec=ne,spin=5,sym=4
        !}
	{rhf
        wf,nele=ne,spin=5,sym=4
        occ,A1,B1,B2,A2
        closed,A1-3,B1-1,B2-1,A2
        }
        !{rhf,nitord=1,maxit=0
        !wf,nele=ne,spin=5,sym=4
        !occ,A1,B1,B2,A2
        !closed,A1-3,B1-1,B2-1,A2
        !}
	scf(i)=energy
	_CC_NORM_MAX=2.0
        !{rccsd(t);maxit,100;core}
        !ccsd(i)=energy
enddo

table,z,scf!,ccsd
save
type,csv

