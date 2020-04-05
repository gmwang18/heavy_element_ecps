***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Ag
Ag  0.0 0.0 0.0
}

basis={
ecp,Ag,28,3,0;
4;1,14.15785184669513,19.0;3,14.82894168055794,268.999185087207470;2,13.47676231887511,-139.56162488297585;2,7.13749122152611,-13.42698085027940;
2;2,13.12240778343841,287.90626688765366;2,6.46413886501787,43.78030937555521;
2;2,13.17817815012192,209.30014321142468;2,5.85839777204788,42.20186230053336;
2;2,11.20727948955295,101.20992134881031;2,5.15247976063475,24.10979657796934;
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
