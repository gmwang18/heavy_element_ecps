***,Calculation for Mo atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,oneint=1.0E-15

geometry={
1
Mo
Mo  0.0 0.0 0.0
}

basis={
ECP,Mo,28,3,0;
4
1 8.235941  14.000000
3 9.958580  115.303174000000
2 4.881780  -14.978390
2 10.074804  -12.940460
2
2 10.141272  180.877034
2 4.475476  24.698656
2
2 8.928054  123.690806
2 3.787021  18.878203
2
2 7.358884  48.296320
2 2.595282  7.982705


include,aug-cc-pwCVTZ.basis
}



include,states.proc


do i=1,16
    if (i.eq.1) then
        IId4s2
    else if (i.eq.2) then
        Id5s1
    else if (i.eq.3) then
        Id5p1
    else if (i.eq.4) then
        EAd5s2
    else if (i.eq.5) then
        IId4s1
    else if (i.eq.6) then
        Id5
    else if (i.eq.7) then
        IId3s2
    else if (i.eq.8) then
        IIId4
    else if (i.eq.9) then
        IVd3
    else if (i.eq.10) then
        Vd2
    else if (i.eq.11) then
        VId1
    else if (i.eq.12) then
        VIp1
    else if (i.eq.13) then
        VI5f1
    else if (i.eq.14) then
        VIIXeandF
    else if (i.eq.15) then
        Xp3
    else if (i.eq.16) then
        XIIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core
    orbital,ignore_error}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
