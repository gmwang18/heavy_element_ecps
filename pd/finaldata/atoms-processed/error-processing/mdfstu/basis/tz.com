***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,4,0;
1; 2,1.000000,0.000000; 
2; 2,12.798825,240.262789; 2,5.800528,34.729961; 
4; 2,11.874697,56.746929; 2,11.474335,113.444417; 2,5.515999,9.345639; 2,5.248043,18.345447; 
4; 2,8.502212,28.595554; 2,7.983324,43.453921; 2,3.107628,1.852286; 2,2.476734,1.406765; 
2; 2,9.679571,-10.987255; 2,9.691349,-14.626190; 
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
