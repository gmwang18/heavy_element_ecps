***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 24.4056352521023, 18.0000000000000; 3, 18.9224507081139, 439.301434537841; 2, 28.9783951933421, -204.020608552661; 2, 16.1986624641032, -24.0838652143398;
2; 2, 16.3468394822125, 258.949148085310; 2, 5.42930605211484, 41.1161630425187;
2; 2, 12.6543556908618, 192.593393917593; 2, 5.72516408602716, 31.1328479663218;
2; 2, 8.17592851393160, 99.0532537736625; 2, 13.8062971075286, 6.19890811519901;
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
