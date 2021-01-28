***,Calculation for W atom, singlet and triplet
memory,3,g
gthresh,twoint=1.0E-15


set,dkroll=1,dkho=10,dkhp=4


geometry={
1
W
W  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVTZ.basis
}



include,states.proc


do i=6,6
    if (i.eq.1) then
        Id4s2
    else if (i.eq.2) then
        Id5s1
    else if (i.eq.3) then
        Id5p1
    else if (i.eq.4) then
        EAd5s2
    else if (i.eq.5) then
        IId4s1
    else if (i.eq.6) then
        IId5
    else if (i.eq.7) then
        IIId4
    else if (i.eq.8) then
        IVd3
    else if (i.eq.9) then
        Vd2
    else if (i.eq.10) then
        VId1
    else if (i.eq.11) then
        VIp1
    else if (i.eq.12) then
        VI5f1
    else if (i.eq.13) then
        VIIXeandF
    else if (i.eq.14) then
        Xp3
    else if (i.eq.15) then
        XIIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t);maxit,100;thresh,coeff=1d-3,energy=1d-5;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save

