***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 14.000000,  18.0000000000000; 3, 14.000000,  252.000000000000; 2, 14.000000, -155.871390000000; 2, 9.6862940, -25.6134440000000;
2; 2, 12.636256,  258.996231000000; 2, 6.026404,   41.6028330000000;
2; 2, 11.431625,  192.637154000000; 2, 5.464900,   30.8540240000000;
2; 2, 8.623710,   96.5560060000000; 2, 3.090920,   4.35433500000000;
include,5Zdebug.basis
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
