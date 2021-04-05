***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
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
{rccsd(t);maxit,200;core}
I_ccsd=energy


basis={
ecp,O,2,1,0
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCVQZ.basis
}


geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,6,7,2;
 occ,1,1,1,0,1,0,0,0;
 open,1.3,1.5
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy


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
ecp,O,2,1,0
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCVQZ.basis
}


!These are the wf cards parameters
ne = 13
symm = 3
ss= 1

!There are irrep cards paramters
A1=3
B1=2
B2=2
A2=0


geometry={
    2
    IO molecule
    I 0.0 0.0 0.0
    O 0.0 0.0 2.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne+1,1,ss-1
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
{mcscf
 start,4202.2
 occ,A1,B1,B2,A2
 closed,A1,B1,B2-1,A2
 wf,ne,symm,ss
 natorb,ci,print
 orbital,5202.2
}
{rhf
 wf,ne,symm,ss
 start,5202.2
 occ,A1,B1,B2,A2
 closed,A1,B1,B2-1,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-I_ccsd-O_ccsd


table,2.20,scf,ccsd,bind
save
type,csv

