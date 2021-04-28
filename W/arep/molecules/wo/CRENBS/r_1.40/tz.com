***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-12


basis={
ECP, w, 60, 4 ;
6; !  ul potential
2,1.16069996,-0.54709101;
2,3.19729996,-9.24740410;
2,8.38640022,-52.48021317;
2,22.00390053,-106.44053650;
2,73.78410339,-320.76925659;
1,241.43850708,-47.99345398;
8; !  s-ul potential
2,2.27020001,-39.29640198;
2,2.63599992,124.15521240;
2,3.46090007,-228.80580139;
2,5.08890009,432.31655884;
2,7.92360020,-361.88928223;
2,12.65060043,357.38705444;
1,35.13869858,30.99152946;
0,32.79159927,6.80353212;
8; !  p-ul potential
2,1.82889998,-31.35513878;
2,2.16409993,103.97112274;
2,2.87249994,-200.15911865;
2,4.19990015,372.58468628;
2,6.40469980,-344.03176880;
2,9.77509975,300.36007690;
1,25.06100082,36.69195175;
0,34.81399918,5.78834915;
8; !  d-ul potential
2,1.33169997,-24.22998619;
2,1.55110002,75.06442261;
2,2.06049991,-149.58029175;
2,2.91930008,267.75427246;
2,4.37589979,-291.28921509;
2,6.54969978,253.97956848;
1,16.10079956,26.81559563;
0,20.45079994,7.90078878;
8; !  f-ul potential
2,0.87849998,37.99953842;
2,0.95969999,-73.81892395;
2,1.22749996,102.53340149;
2,1.33510005,-60.67398453;
2,3.73200011,25.93541336;
2,10.76949978,93.24456787;
1,28.34440041,33.22473145;
0,66.98750305,1.05253196;

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
ECP, o, 2, 1 ;
3; !  ul potential
2,10.02859998,-0.79842000;
2,34.19799995,-5.76684701;
1,100.00389957,-1.48645601;
4; !  s-ul potential
2,2.24790001,11.21630394;
2,2.40490001,-16.34447694;
1,4.37400001,1.04294400;
0,2.18920001,2.19389099;
include,../generate/O-aug-cc-pwCVTZ.basis
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
 closed,1,1,0,0,0,0,0,0;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy



basis={
ECP, w, 60, 4 ;
6; !  ul potential
2,1.16069996,-0.54709101;
2,3.19729996,-9.24740410;
2,8.38640022,-52.48021317;
2,22.00390053,-106.44053650;
2,73.78410339,-320.76925659;
1,241.43850708,-47.99345398;
8; !  s-ul potential
2,2.27020001,-39.29640198;
2,2.63599992,124.15521240;
2,3.46090007,-228.80580139;
2,5.08890009,432.31655884;
2,7.92360020,-361.88928223;
2,12.65060043,357.38705444;
1,35.13869858,30.99152946;
0,32.79159927,6.80353212;
8; !  p-ul potential
2,1.82889998,-31.35513878;
2,2.16409993,103.97112274;
2,2.87249994,-200.15911865;
2,4.19990015,372.58468628;
2,6.40469980,-344.03176880;
2,9.77509975,300.36007690;
1,25.06100082,36.69195175;
0,34.81399918,5.78834915;
8; !  d-ul potential
2,1.33169997,-24.22998619;
2,1.55110002,75.06442261;
2,2.06049991,-149.58029175;
2,2.91930008,267.75427246;
2,4.37589979,-291.28921509;
2,6.54969978,253.97956848;
1,16.10079956,26.81559563;
0,20.45079994,7.90078878;
8; !  f-ul potential
2,0.87849998,37.99953842;
2,0.95969999,-73.81892395;
2,1.22749996,102.53340149;
2,1.33510005,-60.67398453;
2,3.73200011,25.93541336;
2,10.76949978,93.24456787;
1,28.34440041,33.22473145;
0,66.98750305,1.05253196;

include,../generate/W-aug-cc-pwCVTZ.basis
ECP, o, 2, 1 ;
3; !  ul potential
2,10.02859998,-0.79842000;
2,34.19799995,-5.76684701;
1,100.00389957,-1.48645601;
4; !  s-ul potential
2,2.24790001,11.21630394;
2,2.40490001,-16.34447694;
1,4.37400001,1.04294400;
0,2.18920001,2.19389099;

include,../generate/O-aug-cc-pwCVTZ.basis
}



!These are the wf cards parameters
ne = 20
symm = 1
ss= 2

!There are irrep cards paramters
A1=6
B1=2
B2=2
A2=1


geometry={
    2
    WO molecule
    W 0.0 0.0 0.0
    O 0.0 0.0 1.40
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-W_ccsd-O_ccsd


table,1.40,scf,ccsd,bind
save
type,csv
