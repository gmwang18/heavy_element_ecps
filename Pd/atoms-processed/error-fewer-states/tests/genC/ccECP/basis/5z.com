***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 23.9598734275342, 18.0000000000000; 3, 22.5402275405088, 431.277721695616; 2, 26.8401961051379, -204.215430312031; 2, 12.3413322982493, -25.0838399615007;
2; 2, 13.4577164802992, 258.834870250450; 2, 5.81154610650445, 39.3171147665406;
2; 2, 12.5353482577362, 192.534922908128; 2, 5.40360550870865, 32.0681862403941;
2; 2, 9.58854287305956, 97.4983291353771; 2, 3.33845370241146, 6.03013586915182;
include,5z.basis
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
