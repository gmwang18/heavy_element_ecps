***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 24.5840978956005, 18.0000000000000; 3, 29.7606383946900, 442.513762120809; 2, 20.3881072553770, -204.224372920102; 2, 5.29980554393793, -24.9863356749038;
2; 2, 9.29840777828651, 261.921940085229; 2, 9.53727293775984, 46.8851816428358;
2; 2, 10.0401946031300, 192.380845006739; 2, 4.60480948748557, 28.8095035731000;
2; 2, 5.99876559915843, 88.0193788695205; 2, 3.87018523315044, -0.2530922754183;
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
