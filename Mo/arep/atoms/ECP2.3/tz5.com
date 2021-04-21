***,Calculation for Mo atom, singlet and triplet
memory,512,mb

!set,dkroll=1,dkho=99,dkhp=2

geometry={
1
Mo
Mo  0.0 0.0 0.0
}

GTHRESH,THROVL=1.d-10

basis={
ECP, mo, 28, 3 ;
5; !  ul potential
2,3.86059999,-2.39912391;
2,10.36299992,-26.34414482;
2,26.72909927,-62.09140015;
2,89.23100281,-163.40112305;
1,279.54220581,-22.59148788;
7; !  s-ul potential
2,2.99819994,48.17292404;
2,3.58340001,-156.71144104;
2,5.01289988,332.59915161;
2,7.67030001,-312.30667114;
2,11.45119953,157.88722229;
1,9.75979996,29.96883774;
0,37.12519836,3.41751909;
7; !  p-ul potential
2,2.94350004,50.96643829;
2,3.45880008,-164.71308899;
2,4.69640017,342.27224731;
2,6.96299982,-351.59188843;
2,10.48050022,269.40219116;
1,29.96489906,14.04963779;
0,26.68639946,5.35105991;
7; !  d-ul potential
2,2.12299991,36.05135727;
2,2.49699998,-117.10117340;
2,3.36770010,232.92193604;
2,4.96120024,-297.79098511;
2,7.39949989,252.18852234;
1,22.86809921,11.67608738;
0,19.53870010,7.26251984;

include,aug-cc-pwCVTZ.basis
}



include,states.proc


do i=5,5
    if (i.eq.1) then
        IId4s2
    else if (i.eq.2) then
        Id5s1
    else if (i.eq.3) then
        Id5p1
    else if (i.eq.4) then
        EAd5s2
    else if (i.eq.5) then
        IId4s1
    else if (i.eq.6) then
        Id5
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
