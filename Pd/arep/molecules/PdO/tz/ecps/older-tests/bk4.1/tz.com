***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={

ECP,Pd,28,3,0;
4; 1, 24.1931165311728, 18.0000000000000; 3, 25.2114235811098, 435.476097561110; 2, 23.1458151879146, -204.320447175046; 2, 9.15894320584622, -25.8273611870623;
2; 2, 11.8450416551530, 259.110283966340; 2, 6.59991920556736, 42.3306237989019;
2; 2, 12.1454432541522, 192.494748003433; 2, 4.95949968679370, 30.0230959610796;
2; 2, 8.14203617958878, 96.2786669870255; 2, 3.40932080212655, 3.73400056136011;
include,Pd-aug-cc-pwCVTZ.basis
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,O-aug-cc-CVTZ.basis
}

OE=-75.09181489
PdE=-5044.366379

A1=6
B1=3
B2=3
A2=1

ne = 24
do i=1,11
	z(i) = 1.985 - 0.05*(i-1)
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
	{rccsd(t);maxit,100;core}
	ccsd(i)=energy
enddo

table,z,scf,ccsd
save
type,csv
