***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 15.84262806907142, 18.0; 3, 15.72406015111702,  285.167305243285560; 2, 16.02839600589630, -160.32173097958560; 2, 10.36159216954606, -1.59457766151929;
2; 2, 12.42397392275981, 240.05917067575049; 2, 5.84656828406173, 34.77687960726364;
2; 2, 11.75057348438128, 170.26506816094110; 2, 5.37214842518733, 27.76335365584542;
2; 2, 7.87880568744106, 72.29141192067181; 2, 3.26213533144017, 3.18267791085429;
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
