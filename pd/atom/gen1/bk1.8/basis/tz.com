***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 7.59479697437236, 18.0000000000000; 3, 10.6886950811061, 136.706345538703 ;2, 11.0936041904834, -153.849509012672;2, 15.6408990630821, -24.4171534740657;
2; 2, 17.7838641742767, 258.060996198544; 2, 3.23756591127384, 24.8824604361583 ; 
2; 2, 12.2878949369780, 191.806922072659; 2, 5.51230388226870, 27.3692585236345 ; 
2; 2, 8.68730314537235, 106.029893137668; 2, 4.10907528108735, 1.75475011435547;
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
