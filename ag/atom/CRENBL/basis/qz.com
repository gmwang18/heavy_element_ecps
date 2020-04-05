***,Calculation for Ag atom, singlet and triplet
memory,512,m

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

geometry={
1
Ag
Ag  0.0 0.0 0.0
}

basis={
ECP, ag, 28, 3 ;
5; !  ul potential
2,6.26410007,-3.58370399;
2,17.34429932,-41.52972031;
2,49.05220032,-90.43763733;
2,167.69929504,-254.95243835;
1,583.98468018,-26.65418816;
7; !  s-ul potential
2,2.66310000,-27.86531448;
2,3.13039994,89.86640167;
2,4.20359993,-176.23782349;
2,6.23330021,323.62954712;
2,8.93859959,-149.80087280;
1,14.17240047,18.86888504;
0,9.84739971,3.26756096;
7; !  p-ul potential
2,2.52550006,-27.75139236;
2,3.00219989,94.34455872;
2,4.04619980,-187.94503784;
2,6.16489983,377.22006226;
2,9.54640007,-298.96502686;
1,14.71339989,56.06618118;
0,99.15979767,4.33762121;
7; !  d-ul potential
2,3.03929996,38.58859253;
2,3.62039995,-126.88704681;
2,5.00589991,263.18853760;
2,7.60449982,-325.30596924;
2,12.02890015,319.68847656;
1,36.31949997,12.95428467;
0,30.56290054,7.22897387;
include,aug-cc-pCVQZ.basis
}

include,states.proc

do i=1,18
    if (i.eq.1) then
        Is1dten
    else if (i.eq.2) then
        As2dten
    else if (i.eq.3) then
        Ip1dten
    else if (i.eq.4) then
        Is2d9
    else if (i.eq.5) then
        IIdten
    else if (i.eq.6) then
        IIs1d9
    else if (i.eq.7) then
        IIId9
    else if (i.eq.8) then
        IVd8
    else if (i.eq.9) then
        Vd7
    else if (i.eq.10) then
        VId6
    else if (i.eq.11) then
        VIId5
    else if (i.eq.12) then
        VIIId4
    else if (i.eq.13) then
        IXd3
    else if (i.eq.14) then
        Xd2
    else if (i.eq.15) then
        XId1
    else if (i.eq.16) then
        XIIKr
    else if (i.eq.17) then
        XVp3
    else if (i.eq.18) then
        XVIIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
