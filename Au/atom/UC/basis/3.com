***,Calculation for Au atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

geometry={
1
Au
Au  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVTZ.basis
}

set,dkroll=1,dkho=10,dkhp=4

include,states.proc

!do i=my_state,my_state
do i=1,13
    if (i.eq.1) then
        Is1dten
    else if (i.eq.2) then
        Ip1dten
    else if (i.eq.3) then
        Is2d9
    else if (i.eq.4) then
        IIdten
    else if (i.eq.5) then
        IIs1d9
    else if (i.eq.6) then
        IIId9
    else if (i.eq.7) then
        IVd8
    else if (i.eq.8) then
        Vd7
    else if (i.eq.9) then
        VId6
    else if (i.eq.10) then
        VIId5
    else if (i.eq.11) then
        XIIXeandF
    else if (i.eq.12) then
        XVp3
    else if (i.eq.13) then
        XVIIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core,8,5,5,2,5,2,2,1}
    ccsd(i)=energy
    {data,rename,4202.2,9202.2}
    {data,rename,5202.2,9202.2}
    {data,rename,6202.2,9202.2}

enddo

table,scf,ccsd
save, 3.csv,new
