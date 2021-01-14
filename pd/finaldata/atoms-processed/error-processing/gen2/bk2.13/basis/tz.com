***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 13.9537849686210, 18.0000000000000; 3, 12.1233395482977, 251.168129435178; 2, 17.5917185690768, -155.718514950584; 2, 10.6678981930962, -25.3122544385072;
2; 2, 14.0044723753409, 258.969665168799; 2, 6.66769341995233, 41.4580550929607;
2; 2, 12.6841939677238, 192.593761190649; 2, 6.12642025191920, 30.6532187076859;
2; 2, 8.64356822184718, 97.0443643713743; 2, 7.19936471038752, 4.26682085755461;
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
