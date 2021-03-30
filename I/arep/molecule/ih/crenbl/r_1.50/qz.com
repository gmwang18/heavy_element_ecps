***,Calculation for ECP IH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP, i, 46, 3 ;
4; !  ul potential
2,0.92250001,-1.44700503;
2,2.56909990,-14.18883228;
2,7.90859985,-43.26330566;
1,25.06110001,-27.74085617;
6; !  s-ul potential
2,1.50360000,-124.03754425;
2,1.87460005,235.54545593;
2,2.68280005,-261.47537231;
2,3.44659996,144.18431091;
1,1.12419999,31.00326920;
0,11.45829964,6.51237297;
6; !  p-ul potential
2,1.24539995,-95.36879730;
2,1.58260000,188.96330261;
2,2.24289989,-221.15356445;
2,2.93009996,104.68045044;
1,0.95029998,30.80925179;
0,12.78199959,5.41463995;
6; !  d-ul potential
2,0.66850001,-50.34055328;
2,0.82800001,102.27642822;
2,1.11570001,-133.29681396;
2,1.41900003,75.01081848;
1,0.50300002,19.15017128;
0,4.55760002,8.09995937;
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
4; !  ul potential
2,0.92250001,-1.44700503;
2,2.56909990,-14.18883228;
2,7.90859985,-43.26330566;
1,25.06110001,-27.74085617;
6; !  s-ul potential
2,1.50360000,-124.03754425;
2,1.87460005,235.54545593;
2,2.68280005,-261.47537231;
2,3.44659996,144.18431091;
1,1.12419999,31.00326920;
0,11.45829964,6.51237297;
6; !  p-ul potential
2,1.24539995,-95.36879730;
2,1.58260000,188.96330261;
2,2.24289989,-221.15356445;
2,2.93009996,104.68045044;
1,0.95029998,30.80925179;
0,12.78199959,5.41463995;
6; !  d-ul potential
2,0.66850001,-50.34055328;
2,0.82800001,102.27642822;
2,1.11570001,-133.29681396;
2,1.41900003,75.01081848;
1,0.50300002,19.15017128;
0,4.55760002,8.09995937;
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
    H 0.0 0.0 1.50
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


table,1.50,scf,ccsd,bind
save
type,csv

