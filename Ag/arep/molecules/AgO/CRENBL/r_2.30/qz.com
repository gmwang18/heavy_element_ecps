***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP, ag, 28, 3 ;
5; !  ul potential
2,6.26410007,-3.58370399;
2,17.34429932,-41.52972031;
2,49.05220032,-90.43763733;
2,167.69929504,-254.95243835;
1,583.98468018,-26.65418816;
7; !  s-ul potential
2,2.66310000,-27.86531448;
2,3.13039994,89.86640167;
2,4.20359993,-176.23782349;
2,6.23330021,323.62954712;
2,8.93859959,-149.80087280;
1,14.17240047,18.86888504;
0,9.84739971,3.26756096;
7; !  p-ul potential
2,2.52550006,-27.75139236;
2,3.00219989,94.34455872;
2,4.04619980,-187.94503784;
2,6.16489983,377.22006226;
2,9.54640007,-298.96502686;
1,14.71339989,56.06618118;
0,99.15979767,4.33762121;
7; !  d-ul potential
2,3.03929996,38.58859253;
2,3.62039995,-126.88704681;
2,5.00589991,263.18853760;
2,7.60449982,-325.30596924;
2,12.02890015,319.68847656;
1,36.31949997,12.95428467;
0,30.56290054,7.22897387;
include,../generate/Ag-aug-cc-pCVQZ.basis
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
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCVQZ.basis
}


geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,6,7,2;
 occ,1,1,1,0,1,0,0,0;
 open,1.3,1.5
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy



basis={
ECP, ag, 28, 3 ;
5; !  ul potential
2,6.26410007,-3.58370399;
2,17.34429932,-41.52972031;
2,49.05220032,-90.43763733;
2,167.69929504,-254.95243835;
1,583.98468018,-26.65418816;
7; !  s-ul potential
2,2.66310000,-27.86531448;
2,3.13039994,89.86640167;
2,4.20359993,-176.23782349;
2,6.23330021,323.62954712;
2,8.93859959,-149.80087280;
1,14.17240047,18.86888504;
0,9.84739971,3.26756096;
7; !  p-ul potential
2,2.52550006,-27.75139236;
2,3.00219989,94.34455872;
2,4.04619980,-187.94503784;
2,6.16489983,377.22006226;
2,9.54640007,-298.96502686;
1,14.71339989,56.06618118;
0,99.15979767,4.33762121;
7; !  d-ul potential
2,3.03929996,38.58859253;
2,3.62039995,-126.88704681;
2,5.00589991,263.18853760;
2,7.60449982,-325.30596924;
2,12.02890015,319.68847656;
1,36.31949997,12.95428467;
0,30.56290054,7.22897387;
include,../generate/Ag-aug-cc-pCVQZ.basis
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCVQZ.basis
}


!These are the wf cards parameters
ne = 25
symm = 3
ss= 1

!There are irrep cards paramters
A1=6
B1=3
B2=3
A2=1


geometry={
    2
    AgO molecule
    Ag 0.0 0.0 0.0
    O 0.0 0.0 2.30
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2-1,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ag_ccsd-O_ccsd


table,2.30,scf,ccsd,bind
save
type,csv

