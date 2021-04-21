***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-12


basis={
ECP,W,60,4,0;
4
1, 10.10386421, 14.0
3, 9.87002398, 141.454098940
2, 10.09655440, -100.01711461
2, 4.88256923, -0.59073932
2
2, 11.15037776, 419.23073839
2, 8.26506574, 41.22363257
3
2, 8.59589461, 321.98210613
2, 2.06675109, -0.23019576
4, 9.59259751, 0.15771279
3
2, 6.06950225, 157.55912074
2, 1.57792527, -0.47994525
4, 6.26456025, -0.15587414
2
2, 2.11699177, 6.24789585
2, 2.00534603, 8.32966134
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
1, 10.10386421, 14.0
3, 9.87002398, 141.454098940
2, 10.09655440, -100.01711461
2, 4.88256923, -0.59073932
2
2, 11.15037776, 419.23073839
2, 8.26506574, 41.22363257
3
2, 8.59589461, 321.98210613
2, 2.06675109, -0.23019576
4, 9.59259751, 0.15771279
3
2, 6.06950225, 157.55912074
2, 1.57792527, -0.47994525
4, 6.26456025, -0.15587414
2
2, 2.11699177, 6.24789585
2, 2.00534603, 8.32966134
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
    H 0.0 0.0 1.30
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


table,1.30,scf,ccsd,bind
save
type,csv
