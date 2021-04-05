***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
5; !  ul potential
2,5.79349995,-3.67986703;
2,15.97259998,-39.08115387;
2,44.46939850,-84.86928558;
2,151.29159546,-237.43994141;
1,516.64819336,-25.76420593;
7; !  s-ul potential
2,2.48130012,-27.05408478;
2,2.93619990,88.65593719;
2,3.97420001,-175.50939941;
2,6.02339983,342.64071655;
2,9.19719982,-222.09843445;
1,13.76439953,51.81674576;
0,89.98899841,2.82314610;
7; !  p-ul potential
2,2.39150000,-28.74325180;
2,2.83590007,94.62859344;
2,3.84990001,-189.17919922;
2,5.86049986,380.36779785;
2,9.15100002,-312.48147583;
1,13.94559956,56.35126877;
0,101.21410370,4.31076288;
7; !  d-ul potential
2,2.88260007,39.28127670;
2,3.44020009,-129.23152161;
2,4.77540016,269.75354004;
2,7.29589987,-337.91909790;
2,11.60599995,324.82962036;
1,36.10689926,13.18474102;
0,30.47970009,7.19891405;
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
