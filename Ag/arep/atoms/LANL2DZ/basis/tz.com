***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Ag
Ag  0.0 0.0 0.0
}

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
include,aug-cc-pCVTZ.basis
}

include,states.proc

do i=1,18
    if (i.eq.1) then
        Is1dten
    else if (i.eq.2) then
        As2dten
    else if (i.eq.3) then
        Ip1dten
    else if (i.eq.4) then
        Is2d9
    else if (i.eq.5) then
        IIdten
    else if (i.eq.6) then
        IIs1d9
    else if (i.eq.7) then
        IIId9
    else if (i.eq.8) then
        IVd8
    else if (i.eq.9) then
        Vd7
    else if (i.eq.10) then
        VId6
    else if (i.eq.11) then
        VIId5
    else if (i.eq.12) then
        VIIId4
    else if (i.eq.13) then
        IXd3
    else if (i.eq.14) then
        Xd2
    else if (i.eq.15) then
        XId1
    else if (i.eq.16) then
        XIIKr
    else if (i.eq.17) then
        XVp3
    else if (i.eq.18) then
        XVIIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
