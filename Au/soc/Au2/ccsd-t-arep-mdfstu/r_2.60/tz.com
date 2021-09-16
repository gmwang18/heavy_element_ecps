***,Calculation for all-electron Au2 molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12


basis={
ECP,Au,60,5,0
1
2,    1.000000,    0.000000
2
2,   13.523218,  426.641867
2,    6.264384,   36.800668
4
2,   11.413867,   87.002091
2,   10.329215,  174.004370
2,    5.707424,    8.870610
2,    4.828165,   17.902438
4
2,    7.430963,   49.883655
2,    8.321990,   74.684549
2,    4.609642,    6.486227
2,    3.511507,    9.546821
2
2,    3.084639,    8.791640
2,    3.024743,   11.658456
2
2,    3.978442,   -5.234337
2,    4.011491,   -6.738142
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
ECP,Au,60,5,0
1
2,    1.000000,    0.000000
2
2,   13.523218,  426.641867
2,    6.264384,   36.800668
4
2,   11.413867,   87.002091
2,   10.329215,  174.004370
2,    5.707424,    8.870610
2,    4.828165,   17.902438
4
2,    7.430963,   49.883655
2,    8.321990,   74.684549
2,    4.609642,    6.486227
2,    3.511507,    9.546821
2
2,    3.084639,    8.791640
2,    3.024743,   11.658456
2
2,    3.978442,   -5.234337
2,    4.011491,   -6.738142
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
    Au 0.0 0.0 2.60
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


table,2.60,scf,ccsd,bind
save
type,csv

