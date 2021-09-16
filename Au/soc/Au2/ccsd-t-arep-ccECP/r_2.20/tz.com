***,Calculation for all-electron Au2 molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12


basis={
ECP,Au,60,4,0
4
1, 9.98526213, 19.00000000
3, 9.53625873, 189.71998048
2, 10.88238997, -140.52864271
2, 3.79228969, -8.41769609
3
2, 13.80917502, 423.15150756
2, 6.57668221, 23.88042962
2, 4.31526601, 12.72961913
3
2, 11.80694221, 260.25598551
2, 5.84381575, 32.79793058
2, 4.46210900, 14.97588650
3
2, 8.63322796, 135.27739451
2, 3.94675337, 12.46465757
2, 4.08160457, 13.92047499
3
2, 3.46716275, 12.31756013
2, 3.59363525, 14.87772240
2, 3.61393523, 15.14359833
include,../generate/Au-aug-cc-pwCVTZ.basis
}


geometry={
    1
    Au atom
    Au 0.0 0.0 0.0
}
{rhf;
 start,atden;
 print,orbitals=2;
 wf,19,1,1;
 occ,4,1,1,1,1,1,1,0;
 open,4.1
 sym,1,1,3,2,1
}
Au_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;core}
Au_ccsd=energy



basis={
ECP,Au,60,4,0
4
1, 9.98526213, 19.00000000
3, 9.53625873, 189.71998048
2, 10.88238997, -140.52864271
2, 3.79228969, -8.41769609
3
2, 13.80917502, 423.15150756
2, 6.57668221, 23.88042962
2, 4.31526601, 12.72961913
3
2, 11.80694221, 260.25598551
2, 5.84381575, 32.79793058
2, 4.46210900, 14.97588650
3
2, 8.63322796, 135.27739451
2, 3.94675337, 12.46465757
2, 4.08160457, 13.92047499
3
2, 3.46716275, 12.31756013
2, 3.59363525, 14.87772240
2, 3.61393523, 15.14359833
include,../generate/Au-aug-cc-pwCVTZ.basis
}



!These are the wf cards parameters
ne = 38
symm = 1
ss= 0

!There are irrep cards paramters
!A1=6
!B1=2
!B2=2
!A2=1


geometry={
    2
    Au2 molecule
    Au 0.0 0.0 0.0
    Au 0.0 0.0 2.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
! occ,A1,B1,B2,A2
! closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Au_ccsd-Au_ccsd


table,2.20,scf,ccsd,bind
save
type,csv

