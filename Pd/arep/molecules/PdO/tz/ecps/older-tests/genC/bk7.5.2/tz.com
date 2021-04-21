***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
4; 1, 23.8229835359140, 18.0000000000000; 3, 23.2098712587099, 428.813703646452; 2, 25.7015359001316, -204.294554641329; 2, 16.8187496653625, -25.2397847891024;
2; 2, 13.7587223897054, 258.184618685624; 2, 5.66344130057258, 36.2474864908563;
2; 2, 14.9281117771099, 191.974006626982; 2, 4.60022752091870, 28.3907322283621;
2; 2, 9.87995768703431, 99.1870280752021; 2, 3.98530216552253, 7.87524802153655;
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
do i=1,3
	z(i) = 1.985 - 0.15*(i-1)
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
