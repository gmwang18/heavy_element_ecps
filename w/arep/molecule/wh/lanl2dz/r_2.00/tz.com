***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-12


basis={
ECP, w, 60, 4 ;
6; !  ul potential
1,839.4489120,-60.0000000;
2,192.8532482,-664.1987920;
2,48.6651974,-238.6143651;
2,12.9221727,-88.4192407;
2,4.5748890,-20.6062326;
2,1.2681796,-0.9283792;
7; !  s-ul potential
0,313.4267518,3.0000000;
1,699.3155462,39.1192967;
2,259.8923741,1180.9692974;
2,85.4999980,728.9564210;
2,22.7635925,293.5591140;
2,4.0764317,562.6731493;
2,3.8827162,-457.3807185;
5; !  p-ul potential
0,224.3926424,2.0000000;
1,61.6736931,63.8948393;
2,19.1469043,205.8901837;
2,3.5565710,312.1427153;
2,3.3263210,-231.3961281;
5; !  d-ul potential
0,161.5278958,3.0000000;
1,75.5814607,55.3315256;
2,38.9115852,267.1976653;
2,12.5426271,146.8485578;
2,3.4615187,44.1055243;
5; !  f-ul potential
0,91.2102727,4.0000000;
1,45.4152756,50.3065523;
2,22.0452967,190.7363098;
2,6.9810413,91.7605552;
2,1.8380480,8.4247312;

include,../generate/W-aug-cc-pwCVTZ.basis
}


geometry={
    1
    W atom
    W 0.0 0.0 0.0
}
{rhf,maxdis=30,iptyp='DIIS',maxit=200; shift,-1.5,-1.0;
 start,atden;
 print,orbitals=2;
 wf,14,1,4
 occ,3,1,1,1,1,1,1,0
 closed,2,1,1,0,1,0,0,0
 sym,1,1,1,3,2
}
W_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
W_ccsd=energy




basis={
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pVTZ.basis
}



geometry={
   1
   Hydrogen
   H 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,1,1,1;
 occ,1,0,0,0,0,0,0,0;
 open,1.1;
}
H_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
H_ccsd=energy




basis={
ECP, w, 60, 4 ;
6; !  ul potential
1,839.4489120,-60.0000000;
2,192.8532482,-664.1987920;
2,48.6651974,-238.6143651;
2,12.9221727,-88.4192407;
2,4.5748890,-20.6062326;
2,1.2681796,-0.9283792;
7; !  s-ul potential
0,313.4267518,3.0000000;
1,699.3155462,39.1192967;
2,259.8923741,1180.9692974;
2,85.4999980,728.9564210;
2,22.7635925,293.5591140;
2,4.0764317,562.6731493;
2,3.8827162,-457.3807185;
5; !  p-ul potential
0,224.3926424,2.0000000;
1,61.6736931,63.8948393;
2,19.1469043,205.8901837;
2,3.5565710,312.1427153;
2,3.3263210,-231.3961281;
5; !  d-ul potential
0,161.5278958,3.0000000;
1,75.5814607,55.3315256;
2,38.9115852,267.1976653;
2,12.5426271,146.8485578;
2,3.4615187,44.1055243;
5; !  f-ul potential
0,91.2102727,4.0000000;
1,45.4152756,50.3065523;
2,22.0452967,190.7363098;
2,6.9810413,91.7605552;
2,1.8380480,8.4247312;

include,../generate/W-aug-cc-pwCVTZ.basis
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pVTZ.basis
}




!These are the wf cards parameters
ne = 15
symm = 1
ss= 5

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    WH molecule
    W 0.0 0.0 0.0
    H 0.0 0.0 2.00
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-W_ccsd-H_ccsd


table,2.00,scf,ccsd,bind
save
type,csv

