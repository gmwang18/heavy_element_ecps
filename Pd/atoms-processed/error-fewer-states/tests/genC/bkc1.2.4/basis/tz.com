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
1, 24.0519043950303, 18.0
3, 17.3825598659121, 432.9342791105454
2, 31.8087999888814, -203.826807056236
2, 7.65585299973193, -25.5822921753985
2
2, 13.8714586388808, 260.048049074394
2, 5.34957449814076, 39.0777938530429
2
2, 11.3233080690637, 193.416544694335
2, 5.66910563969900, 31.1290591891803
2
2, 9.30333079634624, 97.6667334887818
2, 2.97987772000651, 5.36435323641098
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
