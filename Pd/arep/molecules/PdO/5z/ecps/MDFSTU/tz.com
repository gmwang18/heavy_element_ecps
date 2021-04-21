***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 4 ;
1; !  ul potential
2,1.0000000,0.0000000;
2; !  s-ul potential
2,12.79882500,240.26278900;
2,5.80052800,34.72996100;
4; !  p-ul potential
2,11.87469700,56.74692900;
2,11.47433500,113.44441700;
2,5.51599900,9.34563900;
2,5.24804300,18.34544700;
4; !  d-ul potential
2,8.50221200,28.59555400;
2,7.98332400,43.45392100;
2,3.10762800,1.85228600;
2,2.47673400,1.40676500;
2; !  f-ul potential
2,9.67957100,-10.98725500;
2,9.69134900,-14.62619000;
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
