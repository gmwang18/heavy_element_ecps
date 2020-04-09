***,Calculation for Au atom
memory,512,m
geometry={
1
Au
Au  0.0 0.0 0.0
}

basis={
! Effective core Potentials
ECP, au, 60, 4 ;
5; !  ul potential
1,622.6287956,-60.0000000;
2,136.2843607,-555.5292312;
2,33.1549781,-168.0019785;
2,9.9894895,-63.0399875;
2,3.0481312,-4.2516681;
6; !  s-ul potential
0,194.7374304,3.0000000;
1,351.5327447,38.6020880;
2,122.3270402,864.8370727;
2,32.0914617,374.9935520;
2,5.2451812,289.7910100;
2,4.4916223,-152.4532773;
4; !  p-ul potential
0,420.6158801,2.0000000;
1,109.4417815,73.8885625;
2,34.1714280,326.6729872;
2,5.9879750,126.5814591;
5; !  d-ul potential
0,219.2666158,3.0000000;
1,122.7297786,55.6793149;
2,63.1063369,449.1987335;
2,18.3684520,215.0269091;
2,4.4972844,64.0840995;
5; !  f-ul potential
0,108.5506037,4.0000000;
1,56.4795527,51.8065335;
2,29.2069159,231.2183113;
2,9.5440543,119.0047386;
2,2.8965118,15.3424188;

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

