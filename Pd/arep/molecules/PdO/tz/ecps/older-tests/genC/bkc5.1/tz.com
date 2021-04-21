***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
4; 1, 23.9598734275342, 18.0000000000000; 3, 22.5402275405088, 431.277721695616; 2, 26.8401961051379, -204.215430312031; 2, 12.3413322982493, -25.0838399615007;
2; 2, 13.4577164802992, 258.834870250450; 2, 5.81154610650445, 39.3171147665406;
2; 2, 12.5353482577362, 192.534922908128; 2, 5.40360550870865, 32.0681862403941;
2; 2, 9.58854287305956, 97.4983291353771; 2, 3.33845370241146, 6.03013586915182;
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
