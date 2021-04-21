***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-12


basis={
ECP,W,60,5,0;
1; 2,1.000000,0.000000; 
2; 2,11.063795,419.227599; 2,8.217641,41.191307; 
6; 2,9.338188,107.348110; 2,8.430448,214.699568; 4,9.490020,0.025442; 4,9.489947,0.051895; 2,1.882997,-0.117184; 2,1.906972,0.296689; 
6; 2,6.205433,58.881279; 2,6.122157,98.683556; 4,6.274556,0.019537; 4,6.226375,0.021956; 2,1.963875,-0.088577; 2,1.888287,-0.209726; 
2; 2,2.307953,6.232472; 2,2.270609,8.311345; 
2; 2,3.583491,-6.802944; 2,3.562515,-8.443232;
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
ECP,O,2,3,0;
1; 2,1.000000,0.000000;
1; 2,12.968600,73.608600;
1; 2,15.243000,-3.917200;
1; 2,9.617200,-0.655900;
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
ECP,W,60,5,0;
1; 2,1.000000,0.000000; 
2; 2,11.063795,419.227599; 2,8.217641,41.191307; 
6; 2,9.338188,107.348110; 2,8.430448,214.699568; 4,9.490020,0.025442; 4,9.489947,0.051895; 2,1.882997,-0.117184; 2,1.906972,0.296689; 
6; 2,6.205433,58.881279; 2,6.122157,98.683556; 4,6.274556,0.019537; 4,6.226375,0.021956; 2,1.963875,-0.088577; 2,1.888287,-0.209726; 
2; 2,2.307953,6.232472; 2,2.270609,8.311345; 
2; 2,3.583491,-6.802944; 2,3.562515,-8.443232;
include,../generate/W-aug-cc-pwCVTZ.basis
ECP,O,2,3,0;
1; 2,1.000000,0.000000;
1; 2,12.968600,73.608600;
1; 2,15.243000,-3.917200;
1; 2,9.617200,-0.655900;
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

