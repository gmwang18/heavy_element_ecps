***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 23.8229835359140, 18.0000000000000; 3, 23.2098712587099, 428.813703646452; 2, 25.7015359001316, -204.294554641329; 2, 16.8187496653625, -25.2397847891024;
2; 2, 13.7587223897054, 258.184618685624; 2, 5.66344130057258, 36.2474864908563;
2; 2, 14.9281117771099, 191.974006626982; 2, 4.60022752091870, 28.3907322283621;
2; 2, 9.87995768703431, 99.1870280752021; 2, 3.98530216552253, 7.87524802153655;
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
