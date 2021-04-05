***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4;1, 24.2603365765997, 18.0000000000000 ;3, 25.3032707779633, 436.686058378795 ;2, 23.0857809463191, -204.297947566349; 2, 9.71893378757434, -25.8702181745121;
2;2, 12.4206494349269, 258.992266560105;2, 5.86928142399022, 41.5742439864688;
2;2, 12.0412041805731, 192.404990668390;2, 4.98927797834334, 29.1227696585488;
2;2, 8.33592711191188, 96.7103668465775;2, 3.74525734358613, 5.18214450046753;
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
