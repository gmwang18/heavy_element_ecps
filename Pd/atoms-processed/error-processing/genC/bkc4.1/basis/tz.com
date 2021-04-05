***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 24.1596507769520, 18.0000000000000; 3, 24.3136619310319, 434.873713985136; 2, 24.4380919979495, -204.259337706551; 2, 9.79448071670401, -25.4987076276579;2; 2, 12.8255418353547, 258.992294496826; 2, 5.88508725637518, 41.4249967992874;
2; 2, 11.2580092924615, 192.756056324210; 2, 5.70705189372168, 32.0936432625384;
2; 2, 8.66932719577235, 96.3183644178232; 2, 3.13418698767624, 4.63698717978271;
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
