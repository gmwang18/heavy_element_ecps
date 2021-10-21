***,Calculation for Te atom
memory,512,m
GTHRESH,THROVL=1.0D-9
geometry={
1
Te
Te  0.0 0.0 0.0
}

basis={
include,pp.molpro

include,Te.aug-cc-pwcvqz-dk3.1.unc.mod.mpro
}

include,states.proc

do i=1,10
if (i.eq.1) then
    Is25p4
else if (i.eq.2) then
    Is25p36s
else if (i.eq.3) then
    Os2p5 
else if (i.eq.4) then
    IIs25p3 
else if (i.eq.5) then
    Is15p4 
else if (i.eq.6) then
    IIs15p35d1
else if (i.eq.7) then
    IIIs25p2
else if (i.eq.8) then
    IVs25p1
else if (i.eq.9) then
    Vs2
else if (i.eq.10) then
    IVs25d1
endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
