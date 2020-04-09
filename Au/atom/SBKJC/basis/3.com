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
1; !  ul potential
1,4.3876300,-10.7235800;
3; !  s-ul potential
0,1.5563600,6.3561200;
2,3.7159300,-364.4403900;
2,4.0679200,428.1975300;
3; !  p-ul potential
0,1.1879800,4.4151800;
2,3.0155100,-136.5755000;
2,3.5958800,194.2053500;
2; !  d-ul potential
0,35.2500000,8.8819800;
2,5.0230700,86.7661200;
1; !  f-ul potential
0,1.6888100,6.2160300;

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

