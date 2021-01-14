***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 30.3483849367978, 18.0000000000000; 3, 30.5696362374828, 546.270928862360; 2, 34.7509755463311, -221.616977900995; 2, 12.4197458017771, -24.3484781883405;
2; 2, 14.9171841133567, 257.804649291562; 2, 4.36617050210703, 29.4800301554224;
2; 2, 12.1493843817530, 192.088431736377; 2, 4.77618298305543, 23.1161315647645;
2; 2, 8.70113792996498, 103.112581943090; 2, 5.71690256199534, 9.48963446115660;
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
