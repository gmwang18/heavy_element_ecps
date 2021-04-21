***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
4; 1, 24.2333944218116, 18.0000000000000; 3, 25.6126129651228, 436.2010995926088; 2, 22.3280589597166, -204.304030580067; 2, 9.73875476855347, -26.0117082040022;
2; 2, 12.7478124128212, 258.988492851081; 2, 5.91948008272005, 41.4384165700823;
2; 2, 12.9389575011795, 192.416033427069; 2, 4.66654359319745, 29.3297065354030;
2; 2, 8.30959332887472, 96.6608452841882; 2, 3.99539065528129, 5.37543248753035;
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
