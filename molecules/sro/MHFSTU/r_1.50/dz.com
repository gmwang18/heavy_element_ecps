***,Calculation for all-electron SrO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP,Sr,28,4,0;
1; 2,1.000000,0.000000; 
2; 2,7.400074,135.889657; 2,3.606379,20.623320; 
2; 2,6.484868,88.527585; 2,3.288053,16.652996; 
2; 2,4.622841,29.860591; 2,2.246904,6.495101; 
1; 2,4.633975,-15.805992; 
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
1; 2,1.000000,0.000000; 
1; 2,12.968600,73.608600; 
1; 2,15.243000,-3.917200; 
1; 2,9.617200,-0.655900;
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
1; 2,1.000000,0.000000; 
2; 2,7.400074,135.889657; 2,3.606379,20.623320; 
2; 2,6.484868,88.527585; 2,3.288053,16.652996; 
2; 2,4.622841,29.860591; 2,2.246904,6.495101; 
1; 2,4.633975,-15.805992; 
include,../generate/Sr-aug-cc-pwCVDZ.basis
ECP,O,2,3,0;
1; 2,1.000000,0.000000; 
1; 2,12.968600,73.608600; 
1; 2,15.243000,-3.917200; 
1; 2,9.617200,-0.655900;
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
    O 0.0 0.0 1.50
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


table,1.50,scf,ccsd,bind
save
type,csv

