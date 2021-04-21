***,Calculation for Au atom, singlet and triplet
memory,512,m
geometry={
1
Au
Au  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVTZ.basis
}

include,states.proc

do i=1,2
    if (i.eq.1) then
        VIId55f1
    else if (i.eq.2) then                                                                                          
        VIId55f1_d
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf,ccsd
save, f_tz.csv,new

