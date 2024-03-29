***,Calculation for Au atom
memory,512,m
geometry={
1
Au
Au  0.0 0.0 0.0
}

basis={
include,bk1.5
include,aug-cc-pwCVTZ.basis
}

include,states.proc

do i=1,15
    if (i.eq.1) then
        Is1dten
    else if (i.eq.2) then
        As2dten
    else if (i.eq.3) then
        Ip1dten
    else if (i.eq.4) then
        Is2d9
    else if (i.eq.5) then
        IIdten
    else if (i.eq.6) then
        IIs1d9
    else if (i.eq.7) then
        IIId9
    else if (i.eq.8) then
        IVd8
    else if (i.eq.9) then
        Vd7
    else if (i.eq.10) then
        VId6
    else if (i.eq.11) then
        VIId5
    else if (i.eq.12) then
        XIIXeandF
    else if (i.eq.13) then
        XVp3
    else if (i.eq.14) then
        XVIIIs2
    else if (i.eq.15) then
        VIId5f1
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo


table,scf,ccsd
save, 3.csv

