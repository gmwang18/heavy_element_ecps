***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4
1, 24.3031917385057, 18.0000000000000
3, 16.8876144213048, 437.457451293103
2, 31.9479075570194, -203.753202000090
2, 7.31161280086433, -25.5893108213846
2
2, 13.8406158836541, 260.039896177824 
2, 5.35996461111704, 38.9172019034759
2
2, 11.7606554635391, 193.467622396191 
2, 5.33791314799587, 30.9628627642171 
2
2, 9.17707666348913, 97.5874186633788
2, 2.95867382179445, 5.17259515974061
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
