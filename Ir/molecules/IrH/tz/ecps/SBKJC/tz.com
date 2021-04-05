***, Calculation for PdH groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym


basis={
ECP, pd, 28, 3 ;
1; !  ul potential
1,8.3432700,-8.3346600;
3; !  s-ul potential
0,1.2131500,3.9780900;
2,4.0330100,218.9925000;
2,3.4577200,-168.4440400;
3; !  p-ul potential
0,1.4560700,4.1402100;
2,4.0551000,108.3260100;
2,3.2161600,-72.8314700;
2; !  d-ul potential
0,19.5447700,3.3061100;
2,5.8466400,52.7880200;
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
