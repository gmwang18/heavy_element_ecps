***,Calculation of binding energy
memory,1,g

gthresh,oneint=1.0E-15
gthresh,twoint=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

ne    =91
symm  =2
ss    =1

A1=21
B1=11
B2=10
A2=4

geometry={
    2
    BiO
    Bi 0.0 0.0 0.0
    O  0.0 0.0 1.5
}

basis={
!include,Bi.pp
include,Bi_contr_TZ.basis
!include,O.pp
include,O_contr_TZ.basis
}
{rhf
 wf,nelec=ne,spin=ss,sym=symm
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 !orbital,2101.2
}

basis={
!include,Bi.pp
include,Bi_aug-cc-pwCVTZ.basis
!include,O.pp
include,O_aug-cc-pwCVTZ.basis
}
{rhf,maxdis=20,iptyp='DIIS',nitord=1,maxit=60; shift,-1.0,-0.5
 wf,nelec=ne,spin=ss,sym=symm
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 print,orbitals=2
 !orbital,ignore_error
}
scf=energy

_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.1,shiftp=0.1,thrdis=1.0;diis,1,1,15,1;maxit,100;core,18,9,9,4
 !orbital,ignore_error
}
ccsd=energy

table,z,scf,ccsd
save, 3.csv, new

