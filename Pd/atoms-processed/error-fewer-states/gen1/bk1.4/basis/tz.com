***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 14.04888416469487, 18.0; 3, 14.19735736458847, 252.87991496450766; 2,     13.22921679776035, -155.8402435777748; 2, 9.40558640091288, -25.619347471551    82;
2; 2, 14.24000755367047, 258.94170780921957; 2, 4.87014304342904, 41.3836053    4833981;
2; 2, 11.56346364891343, 192.67572686061499; 2, 5.20251484557254, 30.9262608    1497210;
2; 2, 8.02364407102633, 96.68105379327490; 2, 3.72883439366362, 4.6591399289    4276; 
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
