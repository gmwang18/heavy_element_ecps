***,Calculation for Au atom, singlet and triplet
memory,512,m
geometry={
1
W
W  0.0 0.0 0.0
}

basis={
ECP,W,60,4,0;
4
1, 10.10386421, 14.0
3, 9.87002398, 141.454098940
2, 10.09655440, -100.01711461
2, 4.88256923, -0.59073932
2
2, 11.15037776, 419.23073839
2, 8.26506574, 41.22363257
3
2, 8.59589461, 321.98210613
2, 2.06675109, -0.23019576
4, 9.59259751, 0.15771279
3
2, 6.06950225, 157.55912074
2, 1.57792527, -0.47994525
4, 6.26456025, -0.15587414
2
2, 2.11699177, 6.24789585
2, 2.00534603, 8.32966134

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
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
