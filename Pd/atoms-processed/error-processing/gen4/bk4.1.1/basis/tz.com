***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 24.68699251817593,  18.0; 3, 31.51001490195423,  444.36586532716674; 2, 20.97544035167687,  -206.3912012945361; 2, 5.14545863497744,  -25.41295844200868;
2; 2, 9.18328323289034,  260.90079799850332; 2, 10.61455290425106,  61.28778683669129; 
2; 2, 10.41682552012734,  192.40022541781607; 2, 4.41606064618619,  30.47645690072801; 
2; 2, 5.96278532528882,  87.88091826674778; 2, 3.97021973512427,  0.14969501684806;
include,5Zdebug.basis
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
