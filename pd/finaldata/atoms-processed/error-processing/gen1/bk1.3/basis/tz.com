***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 29.98010039312101, 18.0; 3, 30.31492216738975, 539.64180707617818; 2,     29.71990516640288, -221.2893100303599; 2, 9.19841405475582, -25.931328606314    21;
2; 2, 13.02821532168227, 258.96390870418941; 2, 5.51442824957305, 41.4874340    9750894;
2; 2, 12.16728327842304, 192.45418048861870; 2, 4.95092504255703, 29.4425756    2205816;
2; 2, 8.36291398417115, 96.73339436911743; 2, 3.66435157975734, 5.1266343107    5356; 
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
