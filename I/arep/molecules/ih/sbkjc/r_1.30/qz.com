***,Calculation for ECP IH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP, i, 46, 3 ;
2; !  ul potential
1,0.9762800,-3.6963900;
1,4.3334300,-14.0030500;
3; !  s-ul potential
0,4.1307100,12.1112300;
2,1.3337500,-41.0920600;
2,1.4912100,70.7376100;
3; !  p-ul potential
0,3.0469200,10.5927100;
2,1.0633900,-46.0227300;
2,1.1440500,65.0504700;
2; !  d-ul potential
0,3.9306300,9.7308900;
2,1.0692000,13.9888000;
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
2; !  ul potential
1,0.9762800,-3.6963900;
1,4.3334300,-14.0030500;
3; !  s-ul potential
0,4.1307100,12.1112300;
2,1.3337500,-41.0920600;
2,1.4912100,70.7376100;
3; !  p-ul potential
0,3.0469200,10.5927100;
2,1.0633900,-46.0227300;
2,1.1440500,65.0504700;
2; !  d-ul potential
0,3.9306300,9.7308900;
2,1.0692000,13.9888000;
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
    H 0.0 0.0 1.30
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


table,1.30,scf,ccsd,bind
save
type,csv

