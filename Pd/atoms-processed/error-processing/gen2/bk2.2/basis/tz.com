***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0
4; 1, 24.2208466343514, 18.0000000000000; 3, 22.3902596603961, 435.975239418325; 2, 26.4307836015692, -204.161890496613; 2, 12.5847464062326, -24.8804430277930;
2; 2, 15.2647048691022, 258.937340585284; 2, 5.29262222406720, 41.5052414450767;
2; 2, 12.6214322198277, 192.592543308402; 2, 5.35940367390921, 30.8641429979988;
2; 2, 7.83763525829835, 97.4266336435290; 2, 14.4531556510715, 5.54420043393210;
include,aug-cc-pwCVTZ.basis
}

include,states.proc

do i=1,13
    if (i.eq.1) then
        Idten
    else if (i.eq.2) then
        EAs2d9
    else if (i.eq.3) then
        Is1d9
    else if (i.eq.4) then
        Is2d8
    else if (i.eq.5) then
        IId9
    else if (i.eq.6) then
        IIs1d8
    else if (i.eq.7) then
        IIId8
    else if (i.eq.8) then
        IVd7
    else if (i.eq.9) then
        Vd6
    else if (i.eq.10) then
        VId5
    else if (i.eq.11) then
        XIKr
    else if (i.eq.12) then
        XIVp3
    else if (i.eq.13) then
        XVIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
