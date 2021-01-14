***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 14.0100368918133, 18.0000000000000 ;3, 13.9062655341665, 252.180664052639 ;2, 14.0527311133463, -155.869769984919;2, 9.69197549665673, -25.6161372177216;
2; 2, 13.2526239731666, 258.980002140443 ;2, 5.50438244561824, 41.5863295387368 ;
2; 2, 11.4531055610280, 192.633017258365 ;2, 5.54662995244484, 30.8570517864830 ;
2; 2, 8.38064254184289, 96.5788916089799 ;2, 3.50159225649715, 4.48095089432726 ;
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
