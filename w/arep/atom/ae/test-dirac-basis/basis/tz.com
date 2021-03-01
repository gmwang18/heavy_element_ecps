***,Calculation for Au atom, singlet and triplet
memory,512,m
geometry={
1
W
W  0.0 0.0 0.0
}

basis={
include,dirac-aug-cc-pwCVTZ.basis
}



include,states.proc


do i=1,4
    if (i.eq.1) then
        Id4s2
    else if (i.eq.2) then
        Id5s1
    else if (i.eq.3) then
        IId4s1
    else if (i.eq.4) then
        IIId4
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf !,ccsd
type,csv
save
