***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 23.88678995458952,  18.0; 3, 29.51138727301336,  429.96221918261136; 2    , 23.81164111104852,  -204.5963018846435; 2, 7.98099759305962, -26.549032952    70440,
2; 2, 14.88473940066190,  258.50063813941978; 2,  4.48163828211663,  40.1413    4922457636 ;
2; 2, 11.53185993456931,  192.31206217978280; 2, 4.91316635886680 , 29.23596    49247791 ;                    
2; 2, 7.78881244812455 , 96.88332943648217; 2, 3.52407080784861 , 3.81715410    995703;
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
