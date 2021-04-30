***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Ag
Ag  0.0 0.0 0.0
}

basis={
!  Q=19., MEFIT, WB, Ref 12.
ECP,Ag,28,4,0;
1; 2,1.000000,0.000000; 
2; 2,13.130000,255.139365; 2,6.510000,36.866122; 
2; 2,11.740000,182.181869; 2,6.200000,30.357751; 
2; 2,10.210000,73.719261; 2,4.380000,12.502117; 
2; 2,14.220000,-33.689920; 2,7.110000,-5.531120; 

include,aug-cc-pCV5Z.basis
}

include,states.proc

do i=1,8
    if (i.eq.1) then
        Is1dten
    else if (i.eq.2) then
        As2dten
    else if (i.eq.3) then
        Ip1dten
    else if (i.eq.4) then
        Is2d9
    else if (i.eq.5) then
        IIdten
    else if (i.eq.6) then
        IIs1d9
    else if (i.eq.7) then
        IIId9
    else if (i.eq.8) then
        IVd8
    else if (i.eq.9) then
        Vd7
    else if (i.eq.10) then
        VId6
    else if (i.eq.11) then
        VIId5
    else if (i.eq.12) then
        VIIId4
    else if (i.eq.13) then
        IXd3
    else if (i.eq.14) then
        Xd2
    else if (i.eq.15) then
        XId1
    else if (i.eq.16) then
        XIIKr
    else if (i.eq.17) then
        XVp3
    else if (i.eq.18) then
        XVIIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
