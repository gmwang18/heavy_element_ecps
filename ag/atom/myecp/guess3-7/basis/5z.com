***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Ag
Ag  0.0 0.0 0.0
}

basis={
ecp,Ag,28,3,0;
4;1,13.77267010944839,19.0;3,14.81922886820121,261.680732079519410;2,13.75989179670326,-138.01583087292425;2,6.82566385641744,-13.37184373426269;
2;2,12.60116356740563,281.41523955021574;2,6.88367816064261,44.08243479840911;
2;2,12.79381197199316,209.51706379773165;2,5.73804504210844,37.83717712637775;
2;2,11.85636822818909,102.59746209646623;2,5.22058633859084,26.74468546082451;
include,aug-cc-pCV5Z.basis
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
