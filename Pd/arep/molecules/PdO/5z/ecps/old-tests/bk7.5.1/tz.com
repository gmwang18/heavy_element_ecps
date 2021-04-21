***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
4; 1, 23.9342914019455, 18.0000000000008; 3, 24.5396652037134, 430.817245235019; 2, 24.1342218754896, -204.349283221636; 2, 12.3781659367445, -25.5367227218382;
2; 2, 12.6181164730679, 259.114696217420; 2, 6.33067934270550, 41.2512660315422;
2; 2, 13.5162295484124, 192.201158304448; 2, 4.78333824906980, 29.4248060180759;
2; 2, 9.52069627456508, 97.0337257675905; 2, 3.53929422042705, 6.86102242614134;
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
