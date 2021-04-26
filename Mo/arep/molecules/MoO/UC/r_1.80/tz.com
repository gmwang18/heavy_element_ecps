***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12


set,dkroll=1,dkho=10,dkhp=4

basis={
include,../generate/Mo-contracted.basis
include,../generate/O-contracted.basis
}


!These are the wf cards parameters
ne = 50
sym = 3
ss= 4

!There are irrep cards paramters


geometry={
    2
    MoO molecule
    Mo 0.0 0.0 0.0
    O 0.0 0.0 1.80
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,sym,ss
 occ,14,6,5,2
 closed,12,5,5,1
 orbital,2101.2
}


basis={
include,../generate/Mo-aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}
{rhf,nitord=1,maxit = 200;
 start,2101.2
 print,orbitals=2;
 wf,ne,sym,ss
 occ,14,6,5,2
 closed,12,5,5,1
}


scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),maxit=100;core,8,3,3,1}
ccsd = energy



basis={
include, ../generate/Mo-aug-cc-pwCVTZ.basis
}
geometry={
    1
    Mo
    Mo 0.0 0.0 0.0
}
{rhf
 wf,42,1,6
 occ,9,3,3,2,3,2,2
 closed,6,3,3,1,3,1,1
}

Mo_scf = energy
_CC_NORM_MAX=2.0
{rccsd(t),maxit=100;core,5,2,2,1,2,1,1}
Mo_ccsd = energy



basis={
include, ../generate/O-aug-cc-pwCVTZ.basis
}
geometry={
    1
    O
    O 0.0 0.0 0.0
}
{rhf
 wf,8,7,2
 occ,2,1,1,0,1,0,0
 closed,2,1,0,0,0,0,0
}

O_scf = energy
_CC_NORM_MAX=2.0
{rccsd(t),maxit=100;core,1,0,0,0,0,0,0}
O_ccsd = energy




table,1.80,scf,ccsd ,Mo_scf,Mo_ccsd,O_scf,O_ccsd
save
type,csv

