***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 9.58214325172766, 18.0000000000000; 3, 11.6723231784356, 172.478578531098; 2, 18.7085745405298, -155.523870667920; 2, 16.4210675912271, -29.3586000047058;
2; 2, 17.8940752327373, 255.779442971832; 2, 3.97287194205114, 19.7130424247801;
2; 2, 15.4603042941301, 190.897111179677; 2, 4.56906612521498, 18.2481679763720;
2; 2, 11.2200333382642, 103.190205845381; 2, 4.37426207981268, 5.54200777742135;
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
