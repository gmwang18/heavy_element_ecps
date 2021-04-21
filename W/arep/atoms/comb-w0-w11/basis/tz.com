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
1, 10.18896000, 14.0
3, 9.47824000, 142.645440000
2, 10.14688000, -100.07872700
2, 5.49165100, -0.94157800
2
2, 11.27395600, 420.47980300
2, 8.41092400, 39.58494300
3
2, 8.51782400, 320.87723500
2, 1.60809100, -0.47282100
4, 10.07349000, 0.11292900
3
2, 6.05928600, 158.07795900
2, 1.10485300, -0.28329900
4, 6.26247700, -0.45949000
2
2, 2.07534200, 7.74540500
2, 1.84594700, 6.91600500

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
