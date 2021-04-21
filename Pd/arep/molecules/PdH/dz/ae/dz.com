***, Calculation for PdH groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ecp,Pd,28,4;
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

include,Pd-aug-cc-pwCVDZ.basis

ecp,H,0,1,0
3
1, 21.24359508259891,   1.00000000000000
3, 21.24359508259891,  21.24359508259891
2, 21.77696655044365, -10.85192405303825
1
2, 1.000000000000000,   0.00000000000000

include,H-aug-cc-pVDZ.basis
}

ne = 19

do i=1,10
	z(i) = 1.537 - 0.1*(i-3)
	geometry={
		2
		PdH
		Pd 0.0 0.0 0.0
		H 0.0 0.0 z(i)
	}
	{rks,pbe0
	wf,nele=ne,spin=1,sym=1
	}
	{rhf
	wf,nelec=ne,spin=1,sym=1
	}
	scf(i)=energy
	_CC_NORM_MAX=2.0
	!{rccsd(t);maxit,100;core}
	!ccsd(i)=energy
enddo

table,z,scf
save
type,csv
