***,Calculation for Ag atom, singlet and triplet
memory,512,m
GTHRESH,THROVL=1.0D-9
geometry={
1
I
I  0.0 0.0 0.0
}

basis={
!  Q=7., MEFIT, WB, Ref 17; CPP: alpha=1.0280;delta=0.8028;ncut=1.
ECP,I,46,4,0;
1; 2,1.000000,0.000000; 
2; 2,3.511200,83.113863; 2,1.755600,5.201876; 
2; 2,2.968800,82.811109; 2,1.484400,3.379682; 
2; 2,1.906600,10.304277; 2,0.953300,7.588032; 
1; 2,2.307500,-21.477936; 

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
