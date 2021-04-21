***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Ag
Ag  0.0 0.0 0.0
}

basis={
ECP,Ag,28,4,3;
1; 2,1.000000,0.000000; 
2; 2,12.567714,255.054771; 2,6.997662,36.983393; 
4; 2,11.316496,60.715705; 2,10.958063,121.443889; 2,7.111400,10.171866; 2,6.773319,20.486564; 
4; 2,8.928437,29.504938; 2,11.102567,44.018736; 2,5.543212,5.368333; 2,3.928835,7.408375; 
2; 2,11.012913,-12.623403; 2,11.019898,-16.764327; 
4; 2,11.316496,-121.431411; 2,10.958063,121.443889; 2,7.111400,-20.343733; 2,6.773319,20.486564; 
4; 2,8.928437,-29.504938; 2,11.102567,29.345824; 2,5.543212,-5.368333; 2,3.928835,4.938916; 
2; 2,11.012913,8.415602; 2,11.019898,-8.382163; 
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
