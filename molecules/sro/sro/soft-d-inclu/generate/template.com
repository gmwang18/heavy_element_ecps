***,Calculation for all-electron SrO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP, sr, 28, 3 ;
3; ! ul potential
1,10.00000, 10.00000;
3,10.00000,100.00000;
2,10.00000,-76.28000;
2; ! s-ul potential
2,7.400074000,135.479430000;
2,3.606379000,17.534463000;
2; ! p-ul potential
2,6.484868000,88.359709000;
2,3.288053000,15.394372000;
2; ! d-ul potential
2,4.622841000,29.888987000;
2,2.246904000,6.659414000;
include,../generate/Sr-aug-cc-pwCVXZ.basis
}

geometry={
    1
    Sr atom
    Sr 0.0 0.0 0.0
}
{rhf;
 start,atden;
 print,orbitals=2;
 wf,10,1,0;
 occ,2,1,1,0,1,0,0,0;
 closed,2,1,1,0,1,0,0,0
 sym,1,1,1
}
Sr_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
Sr_ccsd=energy



basis={
ecp,O,2,1,0
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
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
ECP, sr, 28, 3 ;
3; ! ul potential
1,10.00000, 10.00000;
3,10.00000,100.00000;
2,10.00000,-76.28000;
2; ! s-ul potential
2,7.400074000,135.479430000;
2,3.606379000,17.534463000;
2; ! p-ul potential
2,6.484868000,88.359709000;
2,3.288053000,15.394372000;
2; ! d-ul potential
2,4.622841000,29.888987000;
2,2.246904000,6.659414000;
include,../generate/Sr-aug-cc-pwCVXZ.basis
ecp,O,2,1,0
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCVXZ.basis
}


!These are the wf cards parameters
ne = 16
symm = 1
ss= 0

!There are irrep cards paramters
A1=4
B1=2
B2=2
A2=0


geometry={
    2
    SrO molecule
    Sr 0.0 0.0 0.0
    O 0.0 0.0 length
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
bind=ccsd-Sr_ccsd-O_ccsd


table,length,scf,ccsd,bind
save
type,csv

