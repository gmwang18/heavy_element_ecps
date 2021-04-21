***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 23.9589129790105, 18.0000000000000; 3, 24.2759726725553, 431.260433622189; 2, 24.6445410528623, -204.338889185343; 2, 9.61037720334701, -25.4521909236764;
2; 2, 11.2242671664371, 259.608016699767; 2, 7.73826981416237, 43.4128324508400;
2; 2, 12.3864946530252, 192.348643885032; 2, 4.99642809657435, 30.0554335855097;
2; 2, 8.43520083790733, 96.2008400914058; 2, 3.37412522154727, 4.18821240490164;
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
