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

do i=1,11
if (i.eq.1) then
    Is25p5
else if (i.eq.2) then
    Os2p6
else if (i.eq.3) then
    IIs25p4
else if (i.eq.4) then
    IIIs25p3
else if (i.eq.5) then
    IVs25p2
else if (i.eq.6) then
    Vs25p1
else if (i.eq.7) then
    VIs2
else if (i.eq.8) then
    Is25p46s
else if (i.eq.9) then
    IIs5p5
else if (i.eq.10) then
    IIs25p35d1
else if (i.eq.11) then
    Vs25d1
endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
