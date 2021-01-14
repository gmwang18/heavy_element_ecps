***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4;1, 29.9957263050991, 18.0000000000000 ;3, 29.9402013865718, 539.923073491 784 ;2, 30.0986729238027, -221.205083592458;2, 11.0213929478264, -25.4587173002829;
2;2, 12.6539373851224, 259.029180316519 ;2, 5.95261709080986, 41.4341399756 355 ;
2;2, 12.3931598740604, 192.271199591328 ;2, 4.88991558222109, 27.3596663329 994 ;
2;2, 8.90045356899825, 97.5164158558880 ;2, 3.80328742171022, 6.44327881746 028 ;
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
