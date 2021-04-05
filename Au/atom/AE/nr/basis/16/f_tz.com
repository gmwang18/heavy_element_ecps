***,Calculation for Au atom, singlet and triplet
memory,1,g
geometry={
1
Au
Au  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVTZ.basis
}

include,states.proc

do i=1,1
    if (i.eq.1) then
        Idtenf1
    endif
    scf(i)=energy
    !_CC_NORM_MAX=2.0
    !{rccsd(t),maxit=100;core}
    !ccsd(i)=energy
enddo

table,scf,ccsd
save, f_tz.csv,new
