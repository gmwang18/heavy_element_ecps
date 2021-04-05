***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 24.1931165311728, 18.0000000000000; 3, 25.2114235811098, 435.476097561110; 2, 23.1458151879146, -204.320447175046; 2, 9.15894320584622, -25.8273611870623;
2; 2, 11.8450416551530, 259.110283966340; 2, 6.59991920556736, 42.3306237989019;
2; 2, 12.1454432541522, 192.494748003433; 2, 4.95949968679370, 30.0230959610796;
2; 2, 8.14203617958878, 96.2786669870255; 2, 3.40932080212655, 3.73400056136011;
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
