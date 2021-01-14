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
1, 24.3057174874803, 18.0000000000000
3, 16.9295071985960, 437.502914774645
2, 32.0448662632198, -203.814229161175
2, 10.1137495867619, -25.1885377416371
2
2, 12.2801500404503, 260.335151631532 
2, 6.87401334205499, 40.1514149485269
2
2, 13.8688515296422, 193.299324881396 
2, 5.04514718857864, 29.4710939670574 
2
2, 10.8829442086159, 97.7477630767140
2, 3.01832526692839, 6.01053832992045
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
