***,Calculation for Au atom, singlet and triplet
memory,512,m
geometry={
1
W
W  0.0 0.0 0.0
}

basis={
ECP, w, 60, 4 ;
6; !  ul potential
1,839.4489120,-60.0000000;
2,192.8532482,-664.1987920;
2,48.6651974,-238.6143651;
2,12.9221727,-88.4192407;
2,4.5748890,-20.6062326;
2,1.2681796,-0.9283792;
7; !  s-ul potential
0,313.4267518,3.0000000;
1,699.3155462,39.1192967;
2,259.8923741,1180.9692974;
2,85.4999980,728.9564210;
2,22.7635925,293.5591140;
2,4.0764317,562.6731493;
2,3.8827162,-457.3807185;
5; !  p-ul potential
0,224.3926424,2.0000000;
1,61.6736931,63.8948393;
2,19.1469043,205.8901837;
2,3.5565710,312.1427153;
2,3.3263210,-231.3961281;
5; !  d-ul potential
0,161.5278958,3.0000000;
1,75.5814607,55.3315256;
2,38.9115852,267.1976653;
2,12.5426271,146.8485578;
2,3.4615187,44.1055243;
5; !  f-ul potential
0,91.2102727,4.0000000;
1,45.4152756,50.3065523;
2,22.0452967,190.7363098;
2,6.9810413,91.7605552;
2,1.8380480,8.4247312;

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
