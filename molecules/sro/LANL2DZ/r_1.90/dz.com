***,Calculation for all-electron SrO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP, sr, 28, 3 ;
5; !  ul potential
0,782.3804631,-0.0384323;
1,124.6542338,-20.6174271;
2,36.9874966,-101.1737744;
2,9.8828819,-38.7743603;
2,3.2829588,-4.6479243;
4; !  s-ul potential
0,59.3240631,2.9989022;
1,55.2038472,25.6552669;
2,20.4692092,183.1818533;
2,3.9588141,58.4384739;
5; !  p-ul potential
0,92.1201991,4.9551189;
1,46.8132559,25.4472367;
2,48.6566432,203.8002780;
2,14.9503238,155.0518740;
2,3.4268785,39.3605192;
5; !  d-ul potential
0,65.8291301,3.0056451;
1,32.7282621,26.7064119;
2,21.1146030,74.5756901;
2,9.1071292,63.1742121;
2,2.8110754,20.2961162;
include,../generate/Sr-aug-cc-pwCVDZ.basis
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
include,../generate/O-aug-cc-pCVDZ.basis
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
5; !  ul potential
0,782.3804631,-0.0384323;
1,124.6542338,-20.6174271;
2,36.9874966,-101.1737744;
2,9.8828819,-38.7743603;
2,3.2829588,-4.6479243;
4; !  s-ul potential
0,59.3240631,2.9989022;
1,55.2038472,25.6552669;
2,20.4692092,183.1818533;
2,3.9588141,58.4384739;
5; !  p-ul potential
0,92.1201991,4.9551189;
1,46.8132559,25.4472367;
2,48.6566432,203.8002780;
2,14.9503238,155.0518740;
2,3.4268785,39.3605192;
5; !  d-ul potential
0,65.8291301,3.0056451;
1,32.7282621,26.7064119;
2,21.1146030,74.5756901;
2,9.1071292,63.1742121;
2,2.8110754,20.2961162;
include,../generate/Sr-aug-cc-pwCVDZ.basis
ecp,O,2,1,0
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCVDZ.basis
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
    O 0.0 0.0 1.90
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


table,1.90,scf,ccsd,bind
save
type,csv

