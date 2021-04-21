***,Calculation for Ag atom, singlet and triplet
memory,512,m
GTHRESH,THROVL=1.0D-9
geometry={
1
I
I  0.0 0.0 0.0
}

basis={
ECP, i, 46, 3 ;
4; !  ul potential
2,0.92250001,-1.44700503;
2,2.56909990,-14.18883228;
2,7.90859985,-43.26330566;
1,25.06110001,-27.74085617;
6; !  s-ul potential
2,1.50360000,-124.03754425;
2,1.87460005,235.54545593;
2,2.68280005,-261.47537231;
2,3.44659996,144.18431091;
1,1.12419999,31.00326920;
0,11.45829964,6.51237297;
6; !  p-ul potential
2,1.24539995,-95.36879730;
2,1.58260000,188.96330261;
2,2.24289989,-221.15356445;
2,2.93009996,104.68045044;
1,0.95029998,30.80925179;
0,12.78199959,5.41463995;
6; !  d-ul potential
2,0.66850001,-50.34055328;
2,0.82800001,102.27642822;
2,1.11570001,-133.29681396;
2,1.41900003,75.01081848;
1,0.50300002,19.15017128;
0,4.55760002,8.09995937;
include,aug-cc-pwCVQZ.basis
}

!set,dkroll=1,dkho=10,dkhp=4

include,states.proc

do i=1,11
if (i.eq.1) then
    Is25p5
else if (i.eq.2) then
    Is25p46s
else if (i.eq.3) then
    Os2p6
else if (i.eq.4) then
    IIs25p4
else if (i.eq.5) then
    IIs5p5
else if (i.eq.6) then
    IIs25p35d1
else if (i.eq.7) then
    IIIs25p3
else if (i.eq.8) then
    IVs25p2
else if (i.eq.9) then
    Vs25p1
else if (i.eq.10) then
    VIs2
else if (i.eq.11) then
    Vs25d1
endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
