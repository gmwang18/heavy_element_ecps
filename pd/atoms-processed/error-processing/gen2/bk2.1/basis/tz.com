***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 28.5739285669493, 18.0000000000000; 3, 21.4859889954870, 514.330714205087; 2, 49.1797848669995, -220.308124226562; 2, 14.6195717284947, -15.7169636164010;
2; 2, 12.9781660809862, 259.310454497449; 2, 6.72966203092044, 44.3340592802775;
2; 2, 11.1520449712768, 194.925053200668; 2, 7.34412230560190, 40.0485556558515;2; 2, 9.21681803877636, 103.837378440476; 2, 4.59986808402552, 7.32865773178229;
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
