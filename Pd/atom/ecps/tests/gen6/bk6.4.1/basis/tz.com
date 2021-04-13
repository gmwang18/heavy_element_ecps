***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 24.2333944218116, 18.0000000000000; 3, 25.6126129651228, 436.2010995926088; 2, 22.3280589597166, -204.304030580067; 2, 9.73875476855347, -26.0117082040022;
2; 2, 12.7478124128212, 258.988492851081; 2, 5.91948008272005, 41.4384165700823;
2; 2, 12.9389575011795, 192.416033427069; 2, 4.66654359319745, 29.3297065354030;
2; 2, 8.30959332887472, 96.6608452841882; 2, 3.99539065528129, 5.37543248753035;
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
