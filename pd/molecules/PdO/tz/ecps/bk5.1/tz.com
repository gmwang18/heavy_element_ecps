***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP,Pd,28,3,0;
4; 1, 23.9589129790105, 18.0000000000000; 3, 24.2759726725553, 431.260433622189; 2, 24.6445410528623, -204.338889185343; 2, 9.61037720334701, -25.4521909236764;
2; 2, 11.2242671664371, 259.608016699767; 2, 7.73826981416237, 43.4128324508400;
2; 2, 12.3864946530252, 192.348643885032; 2, 4.99642809657435, 30.0554335855097;
2; 2, 8.43520083790733, 96.2008400914058; 2, 3.37412522154727, 4.18821240490164;
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
