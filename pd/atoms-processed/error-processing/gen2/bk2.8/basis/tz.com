***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 25.0594188552310, 18.0000000000000; 3, 23.6511816340723, 451.069539394158; 2, 28.8030155226548, -203.409748930074; 2, 12.4699721284773, -23.3266805647439;
2; 2, 15.1358802041785, 258.305252603339; 2, 4.29836841520342, 28.3417379613090;
2; 2, 12.5885248259889, 192.713137239773; 2, 4.83658459933888, 24.6754924950126;
2; 2, 8.80972576457668, 102.737742689972; 2, 5.40141245527205, 8.47487193651927;
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
