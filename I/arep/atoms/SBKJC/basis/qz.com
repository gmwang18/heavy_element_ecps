***,Calculation for Ag atom, singlet and triplet
memory,512,m
GTHRESH,THROVL=1.0D-9
geometry={
1
I
I  0.0 0.0 0.0
}

basis={
ECP, i, 46, 3 ;
2; !  ul potential
1,0.9762800,-3.6963900;
1,4.3334300,-14.0030500;
3; !  s-ul potential
0,4.1307100,12.1112300;
2,1.3337500,-41.0920600;
2,1.4912100,70.7376100;
3; !  p-ul potential
0,3.0469200,10.5927100;
2,1.0633900,-46.0227300;
2,1.1440500,65.0504700;
2; !  d-ul potential
0,3.9306300,9.7308900;
2,1.0692000,13.9888000;
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
