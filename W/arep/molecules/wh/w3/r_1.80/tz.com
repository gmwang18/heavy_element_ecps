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
    H 0.0 0.0 1.80
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


table,1.80,scf,ccsd,bind
save
type,csv

