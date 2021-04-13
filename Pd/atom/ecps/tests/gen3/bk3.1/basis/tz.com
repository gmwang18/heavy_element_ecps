***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 25.0385100005981, 18.0000000000000; 3, 499.998738763651, 450.693180010766; 2, 29.4469061412856, -203.301363406623; 2, 13.2374645686305, -23.1775309189917;2; 2, 16.7821432575305, 258.350957356556; 2, 3.62477653886187, 27.9882039814137;
2; 2, 11.8793046040502, 192.887653955088; 2, 5.04324397218158, 24.8950421757119;
2; 2, 8.36686863772618, 103.120632144645; 2, 6.93311185000424, 9.17736698153830;
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
