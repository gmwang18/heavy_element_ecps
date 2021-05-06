***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12


basis={
ECP,I,46,4,3;
1; 2,1.000000,0.000000; 
2; 2,3.380230,83.107547; 2,1.973454,5.099343; 
4; 2,2.925323,27.299020; 2,3.073557,55.607847; 2,1.903188,0.778322; 2,1.119689,1.751128; 
4; 2,1.999036,8.234552; 2,1.967767,12.488097; 2,0.998982,2.177334; 2,0.972272,3.167401; 
4; 2,2.928812,-11.777154; 2,2.904069,-15.525522; 2,0.287352,-0.148550; 2,0.489380,-0.273682; 
4; 2,2.925323,-54.598040; 2,3.073557,55.607847; 2,1.903188,-1.556643; 2,1.119689,1.751128; 
4; 2,1.999036,-8.234552; 2,1.967767,8.325398; 2,0.998982,-2.177334; 2,0.972272,2.111601; 
4; 2,2.928812,7.851436; 2,2.904069,-7.762761; 2,0.287352,0.099033; 2,0.489380,-0.136841;
include,../generate/I-aug-cc-pwCVXZ.basis
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
include,../generate/O-aug-cc-pCVXZ.basis
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
ECP,I,46,4,3;
1; 2,1.000000,0.000000; 
2; 2,3.380230,83.107547; 2,1.973454,5.099343; 
4; 2,2.925323,27.299020; 2,3.073557,55.607847; 2,1.903188,0.778322; 2,1.119689,1.751128; 
4; 2,1.999036,8.234552; 2,1.967767,12.488097; 2,0.998982,2.177334; 2,0.972272,3.167401; 
4; 2,2.928812,-11.777154; 2,2.904069,-15.525522; 2,0.287352,-0.148550; 2,0.489380,-0.273682; 
4; 2,2.925323,-54.598040; 2,3.073557,55.607847; 2,1.903188,-1.556643; 2,1.119689,1.751128; 
4; 2,1.999036,-8.234552; 2,1.967767,8.325398; 2,0.998982,-2.177334; 2,0.972272,2.111601; 
4; 2,2.928812,7.851436; 2,2.904069,-7.762761; 2,0.287352,0.099033; 2,0.489380,-0.136841;
include,../generate/I-aug-cc-pwCVXZ.basis
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCVXZ.basis
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
    O 0.0 0.0 length
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


table,length,scf,ccsd,bind
save
type,csv

