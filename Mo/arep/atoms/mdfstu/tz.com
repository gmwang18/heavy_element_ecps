***,Calculation for Mo atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15

geometry={
1
Mo
Mo  0.0 0.0 0.0
}

basis={
ECP,Mo,28,4,3;
1; 2,1.000000,0.000000; 
2; 2,10.097000,180.076853; 2,4.375670,24.715920; 
4; 2,9.126564,41.227678; 2,8.863223,82.452670; 2,4.044948,6.345092; 2,3.866657,12.458423; 
4; 2,7.535754,19.308744; 2,7.278976,28.977674; 2,2.763205,3.189516; 2,2.772085,4.700169; 
2; 2,6.306633,-7.178888; 2,6.356448,-9.745978; 
4; 2,9.126564,-82.455357; 2,8.863223,82.452670; 2,4.044948,-12.690183; 2,3.866657,12.458423; 
4; 2,7.535754,-19.308744; 2,7.278976,19.318449; 2,2.763205,-3.189516; 2,2.772085,3.133446; 
2; 2,6.306633,4.785926; 2,6.356448,-4.872989; 

include,aug-cc-pwCVTZ.basis
}



include,states.proc


do i=1,16
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
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core
    orbital,ignore_error}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save