***, Calculation for PdH groundstate
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12
!symmetry,nosym


basis={
ECP, pd, 28, 3 ;
5; !  ul potential
0,598.3336444,-0.0563177;
1,162.4298290,-20.1288036;
2,51.5714771,-105.8197923;
2,16.4888260,-42.5733345;
2,5.8287656,-3.6165086;
5; !  s-ul potential
0,73.3806304,3.0003651;
1,14.7550438,32.4350093;
2,17.8350204,459.0830383;
2,12.7111477,-868.0629029;
2,9.3292063,514.4726098;
5; !  p-ul potential
0,55.6689877,4.9593099;
1,64.2337771,21.1711029;
2,17.6254952,605.0560092;
2,11.9058155,-726.9641846;
2,8.5100832,396.3274883;
5; !  d-ul potential
0,49.9994728,3.0508745;
1,39.7477547,22.2506580;
2,11.4321366,674.8357698;
2,9.1790080,-1040.8554048;
2,7.5624429,505.9375147;
include,5z.basis
ecp,H,0,1,0
3
1, 21.24359508259891,   1.00000000000000
3, 21.24359508259891,  21.24359508259891
2, 21.77696655044365, -10.85192405303825
1
2, 1.000000000000000,   0.00000000000000
include,H-aug-cc-pV5Z.basis
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
