***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-12


basis={
ECP,W,60,4,0;
4
1, 8.29303879, 14.0
3, 8.07451882, 116.102543060
2, 7.68491424, -79.93363848
2, 6.81955040, -5.60171916
2
2, 10.82514492, 419.22749729
2, 8.51109905, 41.32131488
3
2, 8.59140053, 321.98296738
2, 2.29577651, 0.20319422
4, 9.49611475, 0.38438602
3
2, 6.08221137, 157.55770092
2, 1.92689791, -0.56271937
4, 6.20286051, 0.32169661
2
2, 2.13474624, 6.27301644
2, 2.00684448, 8.32124094
include,../generate/W-aug-cc-pwCVTZ.basis
}


geometry={
    1
    W atom
    W 0.0 0.0 0.0
}
{rhf,maxdis=30,iptyp='DIIS',maxit=200; shift,-1.5,-1.0;
 start,atden;
 print,orbitals=2;
 wf,14,1,4
 occ,3,1,1,1,1,1,1,0
 closed,2,1,1,0,1,0,0,0
 sym,1,1,1,3,2
}
W_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
W_ccsd=energy




basis={
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pVTZ.basis
}



geometry={
   1
   Hydrogen
   H 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,1,1,1;
 occ,1,0,0,0,0,0,0,0;
 open,1.1;
}
H_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
H_ccsd=energy




basis={
ECP,W,60,4,0;
4
1, 8.29303879, 14.0
3, 8.07451882, 116.102543060
2, 7.68491424, -79.93363848
2, 6.81955040, -5.60171916
2
2, 10.82514492, 419.22749729
2, 8.51109905, 41.32131488
3
2, 8.59140053, 321.98296738
2, 2.29577651, 0.20319422
4, 9.49611475, 0.38438602
3
2, 6.08221137, 157.55770092
2, 1.92689791, -0.56271937
4, 6.20286051, 0.32169661
2
2, 2.13474624, 6.27301644
2, 2.00684448, 8.32124094
include,../generate/W-aug-cc-pwCVTZ.basis
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pVTZ.basis
}




!These are the wf cards parameters
ne = 15
symm = 1
ss= 5

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    WH molecule
    W 0.0 0.0 0.0
    H 0.0 0.0 1.90
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-W_ccsd-H_ccsd


table,1.90,scf,ccsd,bind
save
type,csv

