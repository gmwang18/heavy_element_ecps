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
ECP, mo, 28, 3 ;
5; !  ul potential
0,537.9667807,-0.0469492;
1,147.8982938,-20.2080084;
2,45.7358898,-106.2116302;
2,13.2911467,-41.8107368;
2,4.7059961,-4.2054103;
3; !  s-ul potential
0,110.2991760,2.8063717;
1,23.2014645,44.5162012;
2,5.3530131,82.7785227;
4; !  p-ul potential
0,63.2901397,4.9420876;
1,23.3315302,25.8604976;
2,24.6759423,132.4708742;
2,4.6493040,57.3149794;
5; !  d-ul potential
0,104.4839977,3.0054591;
1,66.2307245,26.3637851;
2,39.1283176,183.3849199;
2,13.1164437,98.4453068;
2,3.6280263,22.4901377;

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
