***,Calculation for Au atom
memory,512,m
geometry={
1
Au
Au  0.0 0.0 0.0
}

basis={
ECP,Au,60,5,0;  !4;
1; 2,1.000000,0.000000;
2; 2,13.523218,426.641867; 2,6.264384,36.800668;
4; 2,11.413867,87.002091; 2,10.329215,174.004370; 2,5.707424,8.870610; 2,4.828165,17.902438;
4; 2,7.430963,49.883655; 2,8.321990,74.684549; 2,4.609642,6.486227; 2,3.511507,9.546821;
2; 2,3.084639,8.791640; 2,3.024743,11.658456;
2; 2,3.978442,-5.234337; 2,4.011491,-6.738142;

!4; 2,11.413867,-174.004182; 2,10.329215,174.004370; 2,5.707424,-17.741219; 2,4.828165,17.902438;
!4; 2,7.430963,-49.883655; 2,8.321990,49.789700; 2,4.609642,-6.486227; 2,3.511507,6.364547;
!2; 2,3.084639,-5.861094; 2,3.024743,5.829228;
!2; 2,3.978442,2.617169; 2,4.011491,-2.695257;

include,aug-cc-pwCVTZ.basis
}

include,states.proc

do i=1,13
    if (i.eq.1) then
        Is1dten
    else if (i.eq.2) then
        Ip1dten
    else if (i.eq.3) then
        Is2d9
    else if (i.eq.4) then
        IIdten
    else if (i.eq.5) then
        IIs1d9
    else if (i.eq.6) then
        IIId9
    else if (i.eq.7) then
        IVd8
    else if (i.eq.8) then
        Vd7
    else if (i.eq.9) then
        VId6
    else if (i.eq.10) then
        VIId5
    else if (i.eq.11) then
        XIIXeandF
    else if (i.eq.12) then
        XVp3
    else if (i.eq.13) then
        XVIIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo


table,scf,ccsd
save, 3.csv,new

