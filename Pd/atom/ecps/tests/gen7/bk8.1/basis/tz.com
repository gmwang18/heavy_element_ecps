***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 24.7761127345381, 18.0000000000000; 3, 32.5472944456907, 445.970029221686; 2, 20.6782951991509, -206.819185559657; 2, 4.77148038619428, -24.7735316541282;
2; 2, 8.94930476893362, 261.305812918436; 2, 11.3517898968488, 64.9360407730391;
2; 2, 10.2974122015893, 192.342498372444; 2, 4.23132091186465, 29.9449286761820;
2; 2, 5.71790967897874, 86.5005226831549; 2, 4.10736935946638, -0.4451655457327;
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
