***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4

basis={
include,../generate/Mo-contracted.basis
include,../generate/H-contracted.basis
}

!These are the wf cards parameters
ne = 43
symm = 1
ss= 5

!There are irrep cards paramters
A1=12
B1=5
B2=5
A2=2


geometry={
    2
    MoH molecule
    Mo 0.0 0.0 0.0
    H 0.0 0.0 1.52
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 orbital,2101.2
}


basis={
include,../generate/Mo-aug-cc-pwCVTZ.basis
include,../generate/H-aug-cc-pVTZ.basis
}

{rhf,nitord=20;
 start,2101.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}


scf=energy

_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,7,3,3,1}
ccsd=energy



geometry={
    1
    Mo atom
    Mo 0.0 0.0 0.0
}

basis={
include,../generate/Mo-aug-cc-pwCVTZ.basis
}
{rhf,
 start,4202.2;
 print,orbitals=2;
 wf,42,1,6;
 occ,9,3,3,2,3,2,2;
 closed,6,3,3,1,3,1,1;
}

Mo_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,5,2,2,1,2,1,1}
Mo_ccsd=energy


basis={
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



table,1.52,scf,ccsd,Mo_scf,Mo_ccsd,H_scf,H_ccsd
save
type,csv
