***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 28.8026651282315, 18.0000000000000; 3, 19.8914123866566, 518.447972308167; 2, 49.2392411693544, -220.294969156461; 2, 15.1758888876579, -15.5425687018649;
2; 2, 13.5604272800791, 259.297473464326; 2, 6.63747141053945, 44.3009252081235;
2; 2, 11.6640883472929, 194.882487195929; 2, 7.02105751262717, 39.9866180492243;
2; 2, 8.91173943711131, 104.205890793898; 2, 6.20258787913311, 9.64447119014338;
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
