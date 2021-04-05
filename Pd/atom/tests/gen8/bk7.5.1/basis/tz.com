***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 23.9342914019455, 18.0000000000008; 3, 24.5396652037134, 430.817245235019; 2, 24.1342218754896, -204.349283221636; 2, 12.3781659367445, -25.5367227218382;
2; 2, 12.6181164730679, 259.114696217420; 2, 6.33067934270550, 41.2512660315422;
2; 2, 13.5162295484124, 192.201158304448; 2, 4.78333824906980, 29.4248060180759;
2; 2, 9.52069627456508, 97.0337257675905; 2, 3.53929422042705, 6.86102242614134;
include,aug-cc-pwCVTZ.basis
}

include,states.proc

do i=1,13
    if (i.eq.1) then
        Idten
    else if (i.eq.2) then
        EAs2d9
    else if (i.eq.3) then
        Is1d9
    else if (i.eq.4) then
        Is2d8
    else if (i.eq.5) then
        IId9
    else if (i.eq.6) then
        IIs1d8
    else if (i.eq.7) then
        IIId8
    else if (i.eq.8) then
        IVd7
    else if (i.eq.9) then
        Vd6
    else if (i.eq.10) then
        VId5
    else if (i.eq.11) then
        XIKr
    else if (i.eq.12) then
        XIVp3
    else if (i.eq.13) then
        XVIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
   {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
