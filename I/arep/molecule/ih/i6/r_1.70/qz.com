***,Calculation for ECP IH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12


basis={
ecp,I,46,3,0;
4;1,12.00133700643870,7.0;3,12.03588188476387,84.009359045070900;2,3.02229605770581,-3.99855926331326;2,0.97790564264594,-3.05030968819261;
2;2,3.15027629678164,114.02376198253975;2,1.00807992250576,1.97414621398431;
2;2,2.95419006710686,111.46658888340824;2,0.73082151298149,1.71024012257927;
2;2,2.60497876641909,45.30084417121436;2,0.89959310734558,8.70429039348615;
include,../generate/I-aug-cc-pwCVQZ.basis
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
include,../generate/H-aug-cc-pVQZ.basis
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
4;1,12.00133700643870,7.0;3,12.03588188476387,84.009359045070900;2,3.02229605770581,-3.99855926331326;2,0.97790564264594,-3.05030968819261;
2;2,3.15027629678164,114.02376198253975;2,1.00807992250576,1.97414621398431;
2;2,2.95419006710686,111.46658888340824;2,0.73082151298149,1.71024012257927;
2;2,2.60497876641909,45.30084417121436;2,0.89959310734558,8.70429039348615;
include,../generate/I-aug-cc-pwCVQZ.basis
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pVQZ.basis
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
    H 0.0 0.0 1.70
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


table,1.70,scf,ccsd,bind
save
type,csv

