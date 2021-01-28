***,Calculation for W atom, singlet and triplet
memory,2,g


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


do i=1,16
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
        IId3s2
    else if (i.eq.8) then
        IIId4
    else if (i.eq.9) then
        IVd3
    else if (i.eq.10) then
        Vd2
    else if (i.eq.11) then
        VId1
    else if (i.eq.12) then
        VIp1
    else if (i.eq.13) then
        VI5f1
    else if (i.eq.14) then
        VIIXeandF
    else if (i.eq.15) then
        Xp3
    else if (i.eq.16) then
        XIIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core,8,5,5,2,5,2,2,1}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save

