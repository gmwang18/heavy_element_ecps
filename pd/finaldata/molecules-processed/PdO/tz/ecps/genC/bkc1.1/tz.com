***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
4; 1, 24.0170974923010, 18.0000000000000; 3, 17.5771903739963, 432.307754861418; 2, 31.7779374495240, -203.829437803907; 2, 7.82693055558091, -25.5886582868625;
2; 2, 13.7306995017940, 260.047271511671; 2, 5.46078249353059, 39.1028243755526;
2; 2, 11.7331775043855, 193.394084238360; 2, 5.43314876671255, 31.0839282014902; 
2; 2, 9.31288693801540, 97.6642045386901; 2, 3.03965658014995, 5.45352609231271;
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
