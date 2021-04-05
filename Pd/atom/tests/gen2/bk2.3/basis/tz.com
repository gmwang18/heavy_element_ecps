***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 14.0230726517095, 18.0000000000000; 3, 13.1420568653125, 252.415307730771; 2, 15.0307120728656, -155.827831025407; 2, 10.0527835561128, -25.5229819595574;
2; 2, 12.8067946186719, 258.993129020566; 2, 6.37813893370353, 41.5789960237624;
2; 2, 11.7092977282066, 192.629825551887; 2, 5.86523184517496, 30.8248010861745;
2; 2, 8.05935992239547, 96.6559807088092; 2, 5.80773451104443, 4.08238701898076;
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
