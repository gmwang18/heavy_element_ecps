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
1, 5.94161533, 14.0 
3, 6.00023589, 83.182614620
2, 5.98440904, -64.99585666
2, 3.80508847, -4.47590821
2
2, 11.1181159, 419.22669776
2, 8.16968963, 41.19711586
3
2, 8.65301127, 321.97649830
2, 2.10711951, 0.17845378
4, 9.49251977, 0.13901196
3
2, 6.20118797, 157.55766101
2, 1.78987101, -0.14242065
4, 6.20383012, -0.08879637
2
2, 2.27890864, 6.24395980
2, 2.18969300, 8.32028365

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
