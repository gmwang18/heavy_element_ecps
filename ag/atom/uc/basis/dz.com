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
include,aug-cc-pCVDZ.basis
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
    {rccsd(t),maxit=100;core,5,2,2,1,2,1,1,0}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
