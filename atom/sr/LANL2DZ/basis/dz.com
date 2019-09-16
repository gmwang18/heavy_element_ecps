***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Sr
Sr  0.0 0.0 0.0
}

basis={
ECP, sr, 28, 3 ;
5; !  ul potential
0,782.3804631,-0.0384323;
1,124.6542338,-20.6174271;
2,36.9874966,-101.1737744;
2,9.8828819,-38.7743603;
2,3.2829588,-4.6479243;
4; !  s-ul potential
0,59.3240631,2.9989022;
1,55.2038472,25.6552669;
2,20.4692092,183.1818533;
2,3.9588141,58.4384739;
5; !  p-ul potential
0,92.1201991,4.9551189;
1,46.8132559,25.4472367;
2,48.6566432,203.8002780;
2,14.9503238,155.0518740;
2,3.4268785,39.3605192;
5; !  d-ul potential
0,65.8291301,3.0056451;
1,32.7282621,26.7064119;
2,21.1146030,74.5756901;
2,9.1071292,63.1742121;
2,2.8110754,20.2961162;
include,aug-cc-pwCVDZ.basis
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
