***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 25.0565031974063, 18.0000000000000; 3, 23.6089311817818, 451.017057553313; 2, 28.8127872917528, -203.408626910169; 2, 12.5486748359939, -23.3268505891941;
2; 2, 14.9375773502970, 258.316521012412; 2, 4.35929618953553, 28.3700444238175;
2; 2, 12.2883342145010, 192.724136945543; 2, 4.97700379509460, 24.7263155965997;
2; 2, 8.73338260041518, 102.730643536362; 2, 5.52938840569228, 8.44930397268990;
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
