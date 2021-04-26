***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-12


basis={
ECP,Ag,28,4,3;
1; 2,1.000000,0.000000;
2; 2,12.567714,255.054771; 2,6.997662,36.983393;
4; 2,11.316496,60.715705; 2,10.958063,121.443889; 2,7.111400,10.171866; 2,6.773319,20.486564;
4; 2,8.928437,29.504938; 2,11.102567,44.018736; 2,5.543212,5.368333; 2,3.928835,7.408375;
2; 2,11.012913,-12.623403; 2,11.019898,-16.764327;
4; 2,11.316496,-121.431411; 2,10.958063,121.443889; 2,7.111400,-20.343733; 2,6.773319,20.486564;
4; 2,8.928437,-29.504938; 2,11.102567,29.345824; 2,5.543212,-5.368333; 2,3.928835,4.938916;
2; 2,11.012913,8.415602; 2,11.019898,-8.382163;
include,../generate/Ag-aug-cc-pCVDZ.basis
}


geometry={
    1
    Ag atom
    Ag 0.0 0.0 0.0
}
{rhf;
 start,atden;
 print,orbitals=2;
 wf,19,1,1;
 occ,4,1,1,1,1,1,1,0;
 open,4.1
 sym,1,1,3,2,1
}
Ag_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
Ag_ccsd=energy



basis={
ECP,Ag,28,4,3;
1; 2,1.000000,0.000000;
2; 2,12.567714,255.054771; 2,6.997662,36.983393;
4; 2,11.316496,60.715705; 2,10.958063,121.443889; 2,7.111400,10.171866; 2,6.773319,20.486564;
4; 2,8.928437,29.504938; 2,11.102567,44.018736; 2,5.543212,5.368333; 2,3.928835,7.408375;
2; 2,11.012913,-12.623403; 2,11.019898,-16.764327;
4; 2,11.316496,-121.431411; 2,10.958063,121.443889; 2,7.111400,-20.343733; 2,6.773319,20.486564;
4; 2,8.928437,-29.504938; 2,11.102567,29.345824; 2,5.543212,-5.368333; 2,3.928835,4.938916;
2; 2,11.012913,8.415602; 2,11.019898,-8.382163;
include,../generate/Ag-aug-cc-pCVDZ.basis
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
    Ag2 molecule
    Ag 0.0 0.0 0.0
    Ag 0.0 0.0 2.60
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
bind=ccsd-Ag_ccsd-Ag_ccsd


table,2.60,scf,ccsd,bind
save
type,csv

