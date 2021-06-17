***,Calculation for Ag atom, singlet and triplet
memory,512,m
GTHRESH,THROVL=1.0D-9
geometry={
1
I
I  0.0 0.0 0.0
}

basis={
ecp,I,46,2,0;
8
1,           2.78984462,           7.00000000
2,           1.22952833,        -791.37096026
2,           1.62271250,         787.20777125
3,           2.39755152,         499.81829670
3,           2.48495958,        -480.28938437
4,           1.37284821,         288.73090447
4,          40.28347089,           3.82175909
4,           5.62064467,          11.84621163
8
2,           1.43762279,        -754.49497618
2,           5.36154949,         758.15439269
3,           1.60094558,         946.77851661
3,           1.83982974,        -988.50187423
3,           6.65391093,          41.72335762
4,           2.48827446,        1737.10186874
4,           3.28028562,        -939.88400146
4,           4.15860321,        2182.98525859
8
2,           1.76415019,       -3970.35198569
2,           5.93918517,        3971.77786685
3,           2.25753801,       25073.76844461
3,           2.43927748,      -31037.23666454
3,           3.19078510,        5963.46821993
4,           1.40922911,          37.11828639
4,           3.06576059,        9897.69873882
4,           5.13443899,        6650.00998321

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
