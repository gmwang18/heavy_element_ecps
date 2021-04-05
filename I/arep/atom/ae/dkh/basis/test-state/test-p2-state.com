***,Calculation for Ag atom, singlet and triplet
memory,512,m
GTHRESH,THROVL=1.0D-9
geometry={
1
I
I  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCVQZ.basis
}

set,dkroll=1,dkho=10,dkhp=4

include,states.proc

do i=1,2
if (i.eq.1) then
    Is25p5
else if (i.eq.2) then
    IVs25p2
endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
