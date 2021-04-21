***,Calculation for Au atom, singlet and triplet
memory,512,m
geometry={
1
W
W  0.0 0.0 0.0
}

basis={
ECP,W,60,5,0;   !,4;
1; 2,1.000000,0.000000; 
2; 2,11.063795,419.227599; 2,8.217641,41.191307; 
6; 2,9.338188,107.348110; 2,8.430448,214.699568; 4,9.490020,0.025442; 4,9.489947,0.051895; 2,1.882997,-0.117184; 2,1.906972,0.296689; 
6; 2,6.205433,58.881279; 2,6.122157,98.683556; 4,6.274556,0.019537; 4,6.226375,0.021956; 2,1.963875,-0.088577; 2,1.888287,-0.209726; 
2; 2,2.307953,6.232472; 2,2.270609,8.311345; 
2; 2,3.583491,-6.802944; 2,3.562515,-8.443232; 

!6; 2,9.338188,-214.696221; 2,8.430448,214.699568; 4,9.490020,-0.050884; 4,9.489947,0.051895; 2,1.882997,0.234369; 2,1.906972,0.296689; 
!6; 2,6.205433,-58.881279; 2,6.122157,65.789037; 4,6.274556,-0.019537; 4,6.226375,0.014638; 2,1.963875,0.088577; 2,1.888287,-0.139817; 
!2; 2,2.307953,-4.154982; 2,2.270609,4.155672; 
!2; 2,3.583491,3.401472; 2,3.562515,-3.377293; 

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
