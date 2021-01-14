***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 24.2334206555235, 18.0000000000000; 3, 25.6131483980071, 436.201571799423; 2, 22.3270210698950, -204.303925880276;2, 9.73971351020090, -26.0119029550594;
2; 2, 12.7475984189616, 258.988382592815; 2, 5.91977566067029, 41.4374594487165;
2; 2, 12.9428045686248, 192.415810227635; 2, 4.66530364408982, 29.3277029563882; 
2; 2, 8.30963412237908, 96.6616181165945; 2, 3.99757789837006, 5.37936745384426;
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
