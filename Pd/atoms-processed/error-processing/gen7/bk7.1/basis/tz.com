***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 23.7676099099381, 18.0000000000000; 3, 23.6835745863191, 427.816978378886; 2, 24.8673021063858, -204.278720274501; 2, 8.23111175883294, -25.4973856006951;
2; 2, 10.5076512941354, 259.851214999749; 2, 9.02426872899396, 44.5234927210219;
2; 2, 12.1557325151291, 192.545186117593; 2, 4.90008014269681, 30.1708481959640;
2; 2, 8.13814685719222, 95.9820762765992; 2, 3.38142203003589, 4.07521494015187;
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
