***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4

!These are the wf cards parameters
ne = 60
symm = 4
ss= 2

!There are irrep cards paramters
A1=15
B1=7
B2=7
A2=2

basis={
include,Te.aug-cc-pwcvqz-dk3.1.unc.mod.mpro
include,O.aug-cc-pCVQZ-DK.unc.mpro
}

geometry={
    2
    TeO molecule
    Te 0.0 0.0 0.0
    O 0.0 0.0 2.10
}
{rhf
 wf,ne,symm,ss
 start,5202.2
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2-1,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,11,5,5,2}
ccsd=energy
bind=ccsd-I_ccsd-O_ccsd


table,2.10,scf,ccsd
save
type,csv

