***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Sr
Sr  0.0 0.0 0.0
}

basis={
ECP, sr, 28, 2 ;
5; ! ul potential
2,4.622841000,29.888987000;
2,2.246904000,6.659414000;
1,10.00000, 10.00000;
3,10.00000,100.00000;
2,10.00000,-76.28000;
4; ! s-ul potential
2,7.400074000,135.479430000;
2,3.606379000,17.534463000;
2,4.622841000,-29.888987000;
2,2.246904000,-6.659414000;
4; ! p-ul potential
2,6.484868000,88.359709000;
2,3.288053000,15.394372000;
2,4.622841000,-29.888987000;
2,2.246904000,-6.659414000;
include,aug-cc-pwCVTZ.basis
}



include,states.proc

do i=1,6
    if (i.eq.1) then
        I5s2
    else if (i.eq.2) then
        I5s5p
    else if (i.eq.3) then
        I5s4d
    else if (i.eq.4) then
        II5s1
    else if (i.eq.5) then
        II4d
    else if (i.eq.6) then
        III4p6
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
