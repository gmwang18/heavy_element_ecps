***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4

basis={
include,O.aug-cc-pCVQZ-DK.unc.mpro
include,Te.aug-cc-pwcvqz-dk3.1.unc.mod.mpro
}

geometry={
    1
    Te atom
    Te 0.0 0.0 0.0
}
{rhf;
 start,atden
 print,orbitals=2
 wf,52,7,2
 occ,9,4,4,2,4,2,2,0
 closed,9,4,3,2,3,2,2,0
}
Te_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core,8,3,3,2,3,2,2,0}
Te_ccsd=energy


geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,8,7,2;
 occ,2,1,1,0,1,0,0,0;
 closed,2,1,0,0,0,0,0,0;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy



table,Te_scf,Te_ccsd,O_scf,O_ccsd
save
type,csv

