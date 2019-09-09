***,Calculation for all-electron SrO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP,Sr,28,4,0;
1; 2,1.,0.; 
2; 2,6.933460990,135.271042909; 2,4.114003832,17.944071402; 
4; 2,7.216816623,29.438081345; 2,7.173696172,58.880674863; 2,3.022798817,4.936282692; 2,2.865699030,9.723352071; 
4; 2,6.321514600,11.907239187; 2,6.391499495,17.859551440; 2,1.769726597,2.199180226; 2,1.636771665,2.893570866; 
2; 2,4.244198396,-5.509333254; 2,4.229164471,-7.304641693; 
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
ECP,O,2,3,0;
1; 2,1.00000000,0.00000000; 
1; 2,10.44567000,50.77106900; 
1; 2,18.04517400,-4.90355100; 
1; 2,8.16479800,-3.31212400;
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
ECP,Sr,28,4,0;
1; 2,1.,0.; 
2; 2,6.933460990,135.271042909; 2,4.114003832,17.944071402; 
4; 2,7.216816623,29.438081345; 2,7.173696172,58.880674863; 2,3.022798817,4.936282692; 2,2.865699030,9.723352071; 
4; 2,6.321514600,11.907239187; 2,6.391499495,17.859551440; 2,1.769726597,2.199180226; 2,1.636771665,2.893570866; 
2; 2,4.244198396,-5.509333254; 2,4.229164471,-7.304641693; 
include,../generate/Sr-aug-cc-pwCVDZ.basis
ECP,O,2,3,0;
1; 2,1.00000000,0.00000000; 
1; 2,10.44567000,50.77106900; 
1; 2,18.04517400,-4.90355100; 
1; 2,8.16479800,-3.31212400;
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
    O 0.0 0.0 1.70
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


table,1.70,scf,ccsd,bind
save
type,csv

