***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12


basis={
include,../generate/Mo.ecp

include,../generate/Mo-aug-cc-pwCVTZ.basis
}

geometry={
    1
    Mo atom
    Mo 0.0 0.0 0.0
}
{rhf
 start,atden;
 print,orbitals=2;
 wf,14,1,6
 occ,4,1,1,1,1,1,1,0
 closed,1,1,1,0,1,0,0,0
 sym,1,1,1,3,2
}
Mo_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
Mo_ccsd=energy



basis={
include,../generate/O.ecp

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
include,../generate/Mo.ecp

include,../generate/Mo-aug-cc-pwCVTZ.basis

include,../generate/O.ecp

include,../generate/O-aug-cc-pwCVTZ.basis
}



!These are the wf cards parameters
ne = 20
symm = 3
ss= 4

!There are irrep cards paramters
A1=6
B1=3
B2=2
A2=1


geometry={
    2
    MoO molecule
    Mo 0.0 0.0 0.0
    O 0.0 0.0 1.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Mo_ccsd-O_ccsd


table,1.20,scf,ccsd,bind
save
type,csv

