***, Calculation for PdO groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym

basis={
ECP, pd, 28, 3 ;
4
1, 24.0519043950303, 18.0
3, 17.3825598659121, 432.9342791105454
2, 31.8087999888814, -203.826807056236
2, 7.65585299973193, -25.5822921753985
2
2, 13.8714586388808, 260.048049074394
2, 5.34957449814076, 39.0777938530429
2
2, 11.3233080690637, 193.416544694335
2, 5.66910563969900, 31.1290591891803
2
2, 9.30333079634624, 97.6667334887818
2, 2.97987772000651, 5.36435323641098
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
do i=1,2
	z(i) = 1.985 - 0.15*(i-1)
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
