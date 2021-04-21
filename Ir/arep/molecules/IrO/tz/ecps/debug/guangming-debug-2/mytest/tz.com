***,Calculation for IrO groundstate
memory,1024,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
                                                                                !symmetry,nosym

basis={
include,../lanl2

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

!A1=7
!B1=3
!B2=3
!A2=1


do i=2,2
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


	{rhf
	wf,nelec=ne
	print,orbitals=2
        }

enddo

table,z,scf!,ccsd
save
type,csv

