***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4

!These are the wf cards parameters
ne = 53
symm = 2
ss= 1

!There are irrep cards paramters
A1=13
B1=6
B2=6
A2=2

basis={
include,Te.aug-cc-pwcvqz-dk3.1.unc.mod.mpro
include,H.aug-cc-pVQZ-DK.mpro
}

geometry={
    2
    TeH molecule
    Te 0.0 0.0 0.0
    H 0.0 0.0 1.70
}
{rhf
 wf,ne,symm,ss
 start,5202.2
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy


!table,1.80,scf,ccsd
!save
!type,csv

