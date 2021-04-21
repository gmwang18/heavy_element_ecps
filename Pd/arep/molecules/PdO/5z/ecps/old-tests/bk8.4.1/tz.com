***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
4; 1, 24.5840978956005, 18.0000000000000; 3, 29.7606383946900, 442.513762120809; 2, 20.3881072553770, -204.224372920102; 2, 5.29980554393793, -24.9863356749038;
2; 2, 9.29840777828651, 261.921940085229; 2, 9.53727293775984, 46.8851816428358;
2; 2, 10.0401946031300, 192.380845006739; 2, 4.60480948748557, 28.8095035731000;
2; 2, 5.99876559915843, 88.0193788695205; 2, 3.87018523315044, -0.2530922754183;
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
