***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
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
{rccsd(t);maxit,200;core}
I_ccsd=energy


basis={
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
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
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
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
    O 0.0 0.0 2.00
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


table,2.00,scf,ccsd,bind
save
type,csv

