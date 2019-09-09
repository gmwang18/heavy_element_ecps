***,Calculation for all-electron SrO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP, sr, 28, 2 ;
5; ! ul potential
2,4.622841000,29.888987000
2,2.246904000,6.659414000
1,18.00000000,10.00000
3,18.00000000,180.00000
2,18.00000000,-103.88000
4; ! s-ul potential
2,7.400074000,135.479430000
2,3.606379000,17.534463000
2,4.622841000,-29.888987000
2,2.246904000,-6.659414000
4; ! p-ul potential
2,6.484868000,88.359709000
2,3.288053000,15.394372000
2,4.622841000,-29.888987000
2,2.246904000,-6.659414000
include,../generate/Sr-aug-cc-pwCVQZ.basis
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
ECP, sr, 28, 2 ;
5; ! ul potential
2,4.622841000,29.888987000
2,2.246904000,6.659414000
1,18.00000000,10.00000
3,18.00000000,180.00000
2,18.00000000,-103.88000
4; ! s-ul potential
2,7.400074000,135.479430000
2,3.606379000,17.534463000
2,4.622841000,-29.888987000
2,2.246904000,-6.659414000
4; ! p-ul potential
2,6.484868000,88.359709000
2,3.288053000,15.394372000
2,4.622841000,-29.888987000
2,2.246904000,-6.659414000
include,../generate/Sr-aug-cc-pwCVQZ.basis
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
    O 0.0 0.0 2.40
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


table,2.40,scf,ccsd,bind
save
type,csv

