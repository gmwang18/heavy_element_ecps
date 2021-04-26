***,Calculation for ECP IH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP, i, 46, 3 ;
5; !  ul potential
0,1.0715702,-0.0747621;
1,44.1936028,-30.0811224;
2,12.9367609,-75.3722721;
2,3.1956412,-22.0563758;
2,0.8589806,-1.6979585;
5; !  s-ul potential
0,127.9202670,2.9380036;
1,78.6211465,41.2471267;
2,36.5146237,287.8680095;
2,9.9065681,114.3758506;
2,1.9420086,37.6547714;
5; !  p-ul potential
0,13.0035304,2.2222630;
1,76.0331404,39.4090831;
2,24.1961684,177.4075002;
2,6.4053433,77.9889462;
2,1.5851786,25.7547641;
5; !  d-ul potential
0,40.4278108,7.0524360;
1,28.9084375,33.3041635;
2,15.6268936,186.9453875;
2,4.1442856,71.9688361;
2,0.9377235,9.3630657;
include,../generate/I-aug-cc-pwCVQZ.basis
}

geometry={
    1
    I atom
    I 0.0 0.0 0.0
}
{rhf;
 start,atden
 print,orbitals=2
 wf,7,5,1
 occ,1,1,1,0,1,0,0,0
 closed,1,1,1,0,0,0,0,0
}
I_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
I_ccsd=energy


basis={
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pVQZ.basis
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
ECP, i, 46, 3 ;
5; !  ul potential
0,1.0715702,-0.0747621;
1,44.1936028,-30.0811224;
2,12.9367609,-75.3722721;
2,3.1956412,-22.0563758;
2,0.8589806,-1.6979585;
5; !  s-ul potential
0,127.9202670,2.9380036;
1,78.6211465,41.2471267;
2,36.5146237,287.8680095;
2,9.9065681,114.3758506;
2,1.9420086,37.6547714;
5; !  p-ul potential
0,13.0035304,2.2222630;
1,76.0331404,39.4090831;
2,24.1961684,177.4075002;
2,6.4053433,77.9889462;
2,1.5851786,25.7547641;
5; !  d-ul potential
0,40.4278108,7.0524360;
1,28.9084375,33.3041635;
2,15.6268936,186.9453875;
2,4.1442856,71.9688361;
2,0.9377235,9.3630657;
include,../generate/I-aug-cc-pwCVQZ.basis
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pVQZ.basis
}



!These are the wf cards parameters
ne = 8
symm = 1
ss= 0

!There are irrep cards paramters
A1=2
B1=1
B2=1
A2=0


geometry={
    2
    IH molecule
    I 0.0 0.0 0.0
    H 0.0 0.0 1.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-I_ccsd-H_ccsd


table,1.20,scf,ccsd,bind
save
type,csv

