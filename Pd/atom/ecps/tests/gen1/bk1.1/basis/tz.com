***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0
4;
1, 19.56105486724111,  18.0
3, 24.99725183567404,  352.098987610339980
2, 25.00248477412223,  -207.02977856456926
2, 9.69893751893152 , -25.61066410505854
2;
2, 12.57884105214531,  259.00348767142810
2, 5.93034432269362 ,   41.60465085158774
2;
2, 11.46076029409731,   192.64017729529050
2, 5.51835295825831 ,  30.84415152896073
2;
2, 8.61693352869326 ,  96.55874799318876
2, 3.11362078653575 ,  4.33474301933741

include,aug-cc-pwCVTZ.basis
}

include,states.proc

do i=1,13
    if (i.eq.1) then
        Idten
    else if (i.eq.2) then
        EAs2d9
    else if (i.eq.3) then
        Is1d9
    else if (i.eq.4) then
        Is2d8
    else if (i.eq.5) then
        IId9
    else if (i.eq.6) then
        IIs1d8
    else if (i.eq.7) then
        IIId8
    else if (i.eq.8) then
        IVd7
    else if (i.eq.9) then
        Vd6
    else if (i.eq.10) then
        VId5
    else if (i.eq.11) then
        XIKr
    else if (i.eq.12) then
        XIVp3
    else if (i.eq.13) then
        XVIIs2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
