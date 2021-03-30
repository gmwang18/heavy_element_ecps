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
5; !  ul potential
0,1.0715702,-0.0747621;
1,44.1936028,-30.0811224;
2,12.9367609,-75.3722721;
2,3.1956412,-22.0563758;
2,0.8589806,-1.6979585;
5; !  s-ul potential
0,127.9202670,2.9380036;
1,78.6211465,41.2471267;
2,36.5146237,287.8680095;
2,9.9065681,114.3758506;
2,1.9420086,37.6547714;
5; !  p-ul potential
0,13.0035304,2.2222630;
1,76.0331404,39.4090831;
2,24.1961684,177.4075002;
2,6.4053433,77.9889462;
2,1.5851786,25.7547641;
5; !  d-ul potential
0,40.4278108,7.0524360;
1,28.9084375,33.3041635;
2,15.6268936,186.9453875;
2,4.1442856,71.9688361;
2,0.9377235,9.3630657;
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
