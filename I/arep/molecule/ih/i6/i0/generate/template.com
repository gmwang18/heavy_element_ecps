***,Calculation for ECP IH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12


basis={
ecp,I,46,3,0;
4;1,12.00004289345765,7.0;3,11.99794916071271,84.000300254203550;2,3.00739024510041,-3.99593716722060;2,0.97186794027349,-3.03570359539406;
2;2,3.15300434776600,114.00019311626669;2,0.99350878904776,1.97406645030389;
2;2,2.99928722495191,111.44850746516235;2,0.69419870705040,1.68487746861971;
2;2,2.59535591276977,45.08699895683564;2,0.89428080423941,8.69446231267450;
include,../generate/I-aug-cc-pwCVXZ.basis
}

geometry={
    1
    I atom
    I 0.0 0.0 0.0
}
{rhf;
 start,atden
 print,orbitals=2
 wf,7,5,1
 occ,1,1,1,0,1,0,0,0
 closed,1,1,1,0,0,0,0,0
}
I_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
I_ccsd=energy


basis={
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pVXZ.basis
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
ecp,I,46,3,0;
4;1,12.00004289345765,7.0;3,11.99794916071271,84.000300254203550;2,3.00739024510041,-3.99593716722060;2,0.97186794027349,-3.03570359539406;
2;2,3.15300434776600,114.00019311626669;2,0.99350878904776,1.97406645030389;
2;2,2.99928722495191,111.44850746516235;2,0.69419870705040,1.68487746861971;
2;2,2.59535591276977,45.08699895683564;2,0.89428080423941,8.69446231267450;
include,../generate/I-aug-cc-pwCVXZ.basis
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pVXZ.basis
}



!These are the wf cards parameters
ne = 8
symm = 1
ss= 0

!There are irrep cards paramters
A1=2
B1=1
B2=1
A2=0


geometry={
    2
    IH molecule
    I 0.0 0.0 0.0
    H 0.0 0.0 length
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-I_ccsd-H_ccsd


table,length,scf,ccsd,bind
save
type,csv

