***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 23.8823307391538, 18.0000000000000; 3, 24.0613101144703, 429.881953304768; 2, 24.7099927906673, -204.301867015598; 2, 8.91397965246918, -25.5052657476796;
2; 2, 10.7696576746299, 259.712757983847; 2, 8.53462335219960, 43.7974505778145;
2; 2, 12.2885419125691, 192.408968754956; 2, 4.94565785120463, 30.0815371084276;
2; 2, 8.32058651331899, 96.1503137850614; 2, 3.43476954213742, 4.35479237022613;
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
