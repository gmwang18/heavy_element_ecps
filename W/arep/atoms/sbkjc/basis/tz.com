***,Calculation for Au atom, singlet and triplet
memory,512,m
geometry={
1
W
W  0.0 0.0 0.0
}

basis={
ECP, w, 60, 4 ;
1; !  ul potential
1,2.0382800,-5.2648000;
3; !  s-ul potential
0,0.9651400,2.4729900;
2,2.6550200,-52.0717800;
2,3.6271300,113.4674500;
3; !  p-ul potential
0,1.2390200,3.9108500;
2,2.5412200,-135.3160700;
2,2.8079700,172.3697600;
2; !  d-ul potential
0,27.5593500,3.8734900;
2,3.5197300,49.5251100;
1; !  f-ul potential
0,1.2056100,6.9947100;

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
