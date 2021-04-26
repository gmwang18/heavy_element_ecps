***,Calculation for Ag atom, singlet and triplet
memory,512,m
GTHRESH,THROVL=1.0D-9
geometry={
1
I
I  0.0 0.0 0.0
}

basis={
ECP,I,46,4,3;
1; 2,1.000000,0.000000; 
2; 2,3.380230,83.107547; 2,1.973454,5.099343; 
4; 2,2.925323,27.299020; 2,3.073557,55.607847; 2,1.903188,0.778322; 2,1.119689,1.751128; 
4; 2,1.999036,8.234552; 2,1.967767,12.488097; 2,0.998982,2.177334; 2,0.972272,3.167401; 
4; 2,2.928812,-11.777154; 2,2.904069,-15.525522; 2,0.287352,-0.148550; 2,0.489380,-0.273682; 
4; 2,2.925323,-54.598040; 2,3.073557,55.607847; 2,1.903188,-1.556643; 2,1.119689,1.751128; 
4; 2,1.999036,-8.234552; 2,1.967767,8.325398; 2,0.998982,-2.177334; 2,0.972272,2.111601; 
4; 2,2.928812,7.851436; 2,2.904069,-7.762761; 2,0.287352,0.099033; 2,0.489380,-0.136841;
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
