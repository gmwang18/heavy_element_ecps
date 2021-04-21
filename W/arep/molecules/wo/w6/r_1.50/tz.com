***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-12


basis={
ECP,W,60,4,0;
4
1, 11.99968019, 14.0
3, 12.08159078, 167.995522660
2, 12.13550684, -129.99496766
2, 10.05779055, 5.41064803
2
2, 11.11577026, 419.22289226
2, 8.21368733, 41.18425291
3
2, 8.68450583, 321.97967683
2, 2.15572922, 0.16526384
4, 9.43197038, -0.04025643
3
2, 6.13708225, 157.55203174
2, 1.75966606, -0.41982089
4, 6.28998408, -0.07460703
2
2, 2.16353997, 6.26078799
2, 2.04371515, 8.33827035
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
1, 11.99968019, 14.0
3, 12.08159078, 167.995522660
2, 12.13550684, -129.99496766
2, 10.05779055, 5.41064803
2
2, 11.11577026, 419.22289226
2, 8.21368733, 41.18425291
3
2, 8.68450583, 321.97967683
2, 2.15572922, 0.16526384
4, 9.43197038, -0.04025643
3
2, 6.13708225, 157.55203174
2, 1.75966606, -0.41982089
4, 6.28998408, -0.07460703
2
2, 2.16353997, 6.26078799
2, 2.04371515, 8.33827035
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
    O 0.0 0.0 1.50
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


table,1.50,scf,ccsd,bind
save
type,csv

