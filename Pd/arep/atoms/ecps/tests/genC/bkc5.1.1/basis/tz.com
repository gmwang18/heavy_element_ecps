***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4
1, 23.9617316525911, 18.0000000000000
3, 22.5395324435605, 431.311169746640
2, 26.8486710521226, -204.214690572947
2, 12.3056407474741, -25.0858854987514
2
2, 13.5573808155313, 258.833728335117
2, 5.76246194816736, 39.3093220576407
2
2, 12.6328484868722, 192.534214532156
2, 5.36368722990439, 32.0577558901176
2
2, 9.59022207297566, 97.4985407825327
2, 3.34448947040464, 6.02925571299540
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
