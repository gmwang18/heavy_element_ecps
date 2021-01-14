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

ne = 18

Ag1=3
B3u=1
B2u=1
B1g=1
B1u=1
B2g=1
B3g=1
Au=0

geometry={
	1
	Pd
	Pd 0.0 0.0 0.0
}
!{rhf
!wf,nelec=ne,spin=0,sym=1
!occ,Ag1,B3u,B2u,B1g,B1u,B2g,B3g,Au
!closed,Ag1,B3u,B2u,B1g,B1u,B2g,B3g,Au
!}
{rhf
 start,atden
 print,orbitals=2
 wf,18,1,0
 occ,3,1,1,1,1,1,1,0
 closed,3,1,1,1,1,1,1,0
 sym,1,1,3,2
}

Pdscf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
Pdccsd=energy

geometry={
	1
	H
	H 0.0 0.0 0.0
}
{rhf
start,atden
print,orbitals=2
wf,1,1,1
occ,1,0,0,0,0,0,0,0
closed,0,0,0,0,0,0,0,0
sym,1,1
}

Hscf=energy
{rccsd(t);maxit,100;core}
Hccsd=energy

table,Pdscf,Hscf,Pdccsd,Hccsd
save
type,csv
