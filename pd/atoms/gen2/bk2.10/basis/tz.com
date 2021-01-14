***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Pd
Pd  0.0 0.0 0.0
}

basis={
ECP,Pd,28,3,0;
4; 1, 25.0572102446241, 18.0; 3, 23.0293821391499, 451.029784403233980; 2, 29.2361205909968, -203.30262198204937; 2, 13.1689070649021, -23.19439166988746;
2; 2, 16.6588813288846, 258.35456392500191; 2, 3.94689847398268, 27.99853165684263;
2; 2, 12.1035764803789, 192.76925341203642; 2, 5.12985583992321, 24.86826473135400;
2; 2, 8.51843478660604, 103.08481832442645; 2, 6.81406063080068, 9.14664036242617;
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
