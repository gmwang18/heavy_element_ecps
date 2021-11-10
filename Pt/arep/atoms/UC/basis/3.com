***,Calculation for Pt atom, singlet and triplet
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

geometry={
1
Pt
pt  0.0 0.0 0.0
}

set,dkroll=1,dkho=10,dkhp=4

include,states.proc

basis={
include,aug-cc-pwCVTZ.basis
}

do i=1,15
    if (i.eq.1) then
        Is1d9
    else if (i.eq.2) then
        EAs2d9
    else if (i.eq.3) then
        Is2d8
    else if (i.eq.4) then
        Idten
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
        Vd5f1
    else if (i.eq.11) then
        VId5
    else if (i.eq.12) then
        Xf1
    else if (i.eq.13) then
        XIKr
    else if (i.eq.14) then
        XIVp3
    else if (i.eq.15) then
        XVIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
   {rccsd(t),maxit=100;core,8,5,5,2,5,2,2,1}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save