***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Ag
Ag  0.0 0.0 0.0
}

basis={
ecp,Ag,28,3,0;
4;1,11.16652525555819,19.0;3,11.70406160263076,212.163979855605610;2,10.86648713827900,-111.56158705715360;2,6.09571166474542,-10.15581711633845;
2;2,12.36921329562086,281.00516070812358;2,7.10568889900954,40.63763819409110;
2;2,11.58423021522997,211.11723100518310;2,6.07233138807513,30.37434051163948;
2;2,10.53830745351985,101.11326797212865;2,4.47217833531319,14.97036502295100;
include,aug-cc-pCVTZ.basis
}

include,states.proc

do i=1,18
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
