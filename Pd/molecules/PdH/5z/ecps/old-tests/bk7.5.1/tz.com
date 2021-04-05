***, Calculation for PdH groundstate
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