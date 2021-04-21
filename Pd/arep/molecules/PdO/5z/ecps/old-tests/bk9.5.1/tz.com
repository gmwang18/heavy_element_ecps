***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
4; 1, 25.9310636966423, 18.0000000000000; 3, 18.5552909391323, 466.759146539561; 2, 20.0837969538371, -204.693799758253; 2, 5.66037053828040, -25.7242195763896;
2; 2, 9.91210795750051, 262.842066513192; 2, 8.76060176165849, 48.2060474388906;
2; 2, 11.1946128234679, 192.413167785927; 2, 3.94572590737332, 23.0711481048493;
2; 2, 6.69160520650926, 90.1333118634304; 2, 2.38182721071420, 0.87485503465918;
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
