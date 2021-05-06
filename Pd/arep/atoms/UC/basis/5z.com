***,Calculation for Ag atom, singlet and triplet
memory,512,m

set,dkroll=1,dkho=10,dkhp=4

geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
include,5z.basis
}

include,states.proc

do i=1,14
    if (i.eq.1) then
        Idten
    else if (i.eq.2) then
        EAs1dten
    else if (i.eq.3) then
        EAs2d9
    else if (i.eq.4) then
        Is1d9
    else if (i.eq.5) then
        Is2d8
    else if (i.eq.6) then
        IId9
    else if (i.eq.7) then
        IIs1d8
    else if (i.eq.8) then
        IIId8
    else if (i.eq.9) then
        IVd7
    else if (i.eq.10) then
        Vd6
    else if (i.eq.11) then
        VId5
    else if (i.eq.12) then
        XIKr
    else if (i.eq.13) then
        XIVp3
    else if (i.eq.14) then
        XVIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core,5,2,2,1,2,1,1,0}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save