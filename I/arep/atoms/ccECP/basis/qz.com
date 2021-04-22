***,Calculation for Ag atom, singlet and triplet
memory,512,m
GTHRESH,THROVL=1.0D-9
geometry={
1
I
I  0.0 0.0 0.0
}

basis={
ecp,I,46,3,0;
4;1,12.00133700643870,7.0;3,12.03588188476387,84.009359045070900;2,3.02229605770581,-3.99855926331326;2,0.97790564264594,-3.05030968819261;
2;2,3.15027629678164,114.02376198253975;2,1.00807992250576,1.97414621398431;
2;2,2.95419006710686,111.46658888340824;2,0.73082151298149,1.71024012257927;
2;2,2.60497876641909,45.30084417121436;2,0.89959310734558,8.70429039348615;
include,aug-cc-pwCVQZ.basis
}

!set,dkroll=1,dkho=10,dkhp=4

include,states.proc

do i=1,11
if (i.eq.1) then
    Is25p5
else if (i.eq.2) then
    Is25p46s
else if (i.eq.3) then
    Os2p6
else if (i.eq.4) then
    IIs25p4
else if (i.eq.5) then
    IIs5p5
else if (i.eq.6) then
    IIs25p35d1
else if (i.eq.7) then
    IIIs25p3
else if (i.eq.8) then
    IVs25p2
else if (i.eq.9) then
    Vs25p1
else if (i.eq.10) then
    VIs2
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
