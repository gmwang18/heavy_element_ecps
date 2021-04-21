***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-12


basis={
ECP,W,60,4,0;
4
1, 15.00565969, 14.0
3, 15.01644927, 210.079235660
2, 15.08336860, -149.99935659
2, 7.92665590, 2.35001522
2
2, 11.10530411, 419.22757664
2, 8.22854383, 41.19011693
3
2, 8.56948256, 321.97710753
2, 2.00320439, -0.20099024
4, 9.51304566, -0.04536967
3
2, 6.14256653, 157.56341672
2, 1.60083614, -0.30765606
4, 6.37659435, 0.17601027
2
2, 2.15623989, 6.26447132
2, 2.01948421, 8.34088144
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
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pwCVTZ.basis
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
 closed,1,1,0,0,0,0,0,0;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy



basis={
ECP,W,60,4,0;
4
1, 15.00565969, 14.0
3, 15.01644927, 210.079235660
2, 15.08336860, -149.99935659
2, 7.92665590, 2.35001522
2
2, 11.10530411, 419.22757664
2, 8.22854383, 41.19011693
3
2, 8.56948256, 321.97710753
2, 2.00320439, -0.20099024
4, 9.51304566, -0.04536967
3
2, 6.14256653, 157.56341672
2, 1.60083614, -0.30765606
4, 6.37659435, 0.17601027
2
2, 2.15623989, 6.26447132
2, 2.01948421, 8.34088144
include,../generate/W-aug-cc-pwCVTZ.basis
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pwCVTZ.basis
}



!These are the wf cards parameters
ne = 20
symm = 1
ss= 2

!There are irrep cards paramters
A1=6
B1=2
B2=2
A2=1


geometry={
    2
    WO molecule
    W 0.0 0.0 0.0
    O 0.0 0.0 1.30
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-W_ccsd-O_ccsd


table,1.30,scf,ccsd,bind
save
type,csv

