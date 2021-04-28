***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 24.0170974923010, 18.0000000000000; 3, 17.5771903739963, 432.307754861418; 2, 31.7779374495240, -203.829437803907; 2, 7.82693055558091, -25.5886582868625;
2; 2, 13.7306995017940, 260.047271511671; 2, 5.46078249353059, 39.1028243755526;
2; 2, 11.7331775043855, 193.394084238360; 2, 5.43314876671255, 31.0839282014902; 
2; 2, 9.31288693801540, 97.6642045386901; 2, 3.03965658014995, 5.45352609231271;
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
