***,Calculation for all-electron AgO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP, ag, 28, 3 ;
5; !  ul potential
0,568.7006237,-0.0587930;
1,162.3579066,-20.1145146;
2,51.1025755,-104.2733114;
2,16.9205822,-40.4539787;
2,6.1669596,-3.4420009;
5; !  s-ul potential
0,76.0974658,2.9861527;
1,15.3327359,35.1576460;
2,18.7715345,450.1809906;
2,13.3663294,-866.0248308;
2,9.8236948,523.1110176;
5; !  p-ul potential
0,56.3318043,4.9640671;
1,69.0609098,21.5028219;
2,19.2717998,546.0275453;
2,12.5770654,-600.3822556;
2,8.7956670,348.2949289;
5; !  d-ul potential
0,53.4641078,3.0467486;
1,40.1975457,23.3656705;
2,11.9086073,777.2540117;
2,9.7528183,-1238.8602423;
2,8.1788997,608.0677121;
include,../generate/Ag-aug-cc-pCV5Z.basis
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
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCV5Z.basis
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
0,568.7006237,-0.0587930;
1,162.3579066,-20.1145146;
2,51.1025755,-104.2733114;
2,16.9205822,-40.4539787;
2,6.1669596,-3.4420009;
5; !  s-ul potential
0,76.0974658,2.9861527;
1,15.3327359,35.1576460;
2,18.7715345,450.1809906;
2,13.3663294,-866.0248308;
2,9.8236948,523.1110176;
5; !  p-ul potential
0,56.3318043,4.9640671;
1,69.0609098,21.5028219;
2,19.2717998,546.0275453;
2,12.5770654,-600.3822556;
2,8.7956670,348.2949289;
5; !  d-ul potential
0,53.4641078,3.0467486;
1,40.1975457,23.3656705;
2,11.9086073,777.2540117;
2,9.7528183,-1238.8602423;
2,8.1788997,608.0677121;
include,../generate/Ag-aug-cc-pCV5Z.basis
ecp,O,2,1,0
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
2,  13.65512,  85.86406
include,../generate/O-aug-cc-pCV5Z.basis
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
    O 0.0 0.0 1.90
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


table,1.90,scf,ccsd,bind
save
type,csv

