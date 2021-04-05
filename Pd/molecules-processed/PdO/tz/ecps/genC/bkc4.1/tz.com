***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
4; 1, 24.1596507769520, 18.0000000000000; 3, 24.3136619310319, 434.873713985136; 2, 24.4380919979495, -204.259337706551; 2, 9.79448071670401, -25.4987076276579;2; 2, 12.8255418353547, 258.992294496826; 2, 5.88508725637518, 41.4249967992874;
2; 2, 11.2580092924615, 192.756056324210; 2, 5.70705189372168, 32.0936432625384;
2; 2, 8.66932719577235, 96.3183644178232; 2, 3.13418698767624, 4.63698717978271;
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
