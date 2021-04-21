***,Calculation of binding energy
memory,1,g

gthresh,oneint=1.0E-15
gthresh,twoint=1.0E-15

set,dkroll=1,dkho=10,dkhp=4

ne    =84
symm  =4
ss    =2

A1=19
B1=10
B2=10
A2=4

geometry={
    2
    BiH
    Bi 0.0 0.0 0.0
    H  0.0 0.0 1.6
}

basis={
!include,Bi.pp
include,Bi_contr_TZ.basis
!include,H.pp
include,H_contr_TZ.basis
}
{rhf
 wf,nelec=ne,spin=ss,sym=symm
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2-1,A2
 !orbital,2101.2
}

basis={
!include,Bi.pp
include,Bi_aug-cc-pwCVTZ.basis
!include,H.pp
include,H_aug-cc-pVTZ.basis
}
{rhf,maxdis=20,iptyp='DIIS',nitord=1,maxit=60; shift,-1.0,-0.5
 wf,nelec=ne,spin=ss,sym=symm
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2-1,A2
 !orbital,ignore_error
}
scf=energy

_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.1,shiftp=0.1,thrdis=1.0;diis,1,1,15,1;maxit,100;core,17,9,9,4
 !orbital,ignore_error
}
ccsd=energy

table,z,scf,ccsd
save, 3.csv, new

