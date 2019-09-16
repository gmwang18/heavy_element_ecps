***,Calculation for Sr atom, singlet and triplet
memory,512,m
geometry={
1
Sr
Sr  0.0 0.0 0.0
}

basis={
ECP,Sr,28,4,0;
1; 2,1.000000,0.000000; 
2; 2,7.400074,135.479430; 2,3.606379,17.534463; 
2; 2,6.484868,88.359709; 2,3.288053,15.394372; 
2; 2,4.622841,29.888987; 2,2.246904,6.659414; 
1; 2,4.633975,-15.805992; 
include,aug-cc-pwCVQZ.basis
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
