***, Calculation for PdH groundstate
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
ecp,H,0,1,0
3
1, 21.24359508259891,   1.00000000000000
3, 21.24359508259891,  21.24359508259891
2, 21.77696655044365, -10.85192405303825
1
2, 1.000000000000000,   0.00000000000000
include,H-aug-cc-pVTZ.basis
}

ne = 19

A1=5
B1=2
B2=2
A2=1

do i=1,11
	z(i) = 1.679 - 0.05*(i-1)
	geometry={
		2
		PdH
		Pd 0.0 0.0 0.0
		H 0.0 0.0 z(i)
	}
	{rhf
	wf,nelec=ne,spin=1,sym=1
	occ,A1,B1,B2,A2
	closed,A1-1,B1,B2,A2
	}
	scf(i)=energy
	_CC_NORM_MAX=2.0
	{rccsd(t);maxit,100;core}
	ccsd(i)=energy
enddo

table,z,scf,ccsd
save
type,csv
