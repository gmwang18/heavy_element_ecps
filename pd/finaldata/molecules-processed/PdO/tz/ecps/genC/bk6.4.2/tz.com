***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
4; 1, 24.2334206555235, 18.0000000000000; 3, 25.6131483980071, 436.201571799423; 2, 22.3270210698950, -204.303925880276;2, 9.73971351020090, -26.0119029550594; 
2; 2, 12.7475984189616, 258.988382592815; 2, 5.91977566067029, 41.4374594487165;
2; 2, 12.9428045686248, 192.415810227635; 2, 4.66530364408982, 29.3277029563882;  
2; 2, 8.30963412237908, 96.6616181165945; 2, 3.99757789837006, 5.37936745384426;
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
