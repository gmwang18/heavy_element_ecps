***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 30.3491781750278, 18.0000000000000; 3, 30.5619677872443, 546.285207150500; 2, 34.7431960729723, -221.606328813082; 2, 12.5001007940658, -24.3405039080176;
2; 2, 14.8361383701923, 257.796497523977; 2, 4.39272447290283, 29.5002173946100;
2; 2, 11.9230132111740, 192.090165941160; 2, 4.89948797357120, 23.1454611558480;
2; 2, 8.62562314646814, 103.115259415777; 2, 5.87730166029121, 9.47342337886476;
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
