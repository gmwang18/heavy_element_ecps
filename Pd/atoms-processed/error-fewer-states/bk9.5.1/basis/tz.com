***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 25.9310636966423, 18.0000000000000; 3, 18.5552909391323, 466.759146539561; 2, 20.0837969538371, -204.693799758253; 2, 5.66037053828040, -25.7242195763896;
2; 2, 9.91210795750051, 262.842066513192; 2, 8.76060176165849, 48.2060474388906;
2; 2, 11.1946128234679, 192.413167785927; 2, 3.94572590737332, 23.0711481048493;
2; 2, 6.69160520650926, 90.1333118634304; 2, 2.38182721071420, 0.87485503465918;
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
