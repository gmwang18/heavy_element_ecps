***,Calculation for all-electron WO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12


basis={
ecp,Ag,28,3,0;
4;1,11.11699601755791,19.0;3,11.30706740194795,211.222924333600290;2,10.88746528420199,-111.38567369335220;2,6.05089592989141,-10.04923439650254;
2;2,12.57067724180113,281.00441811099660;2,7.07522814100377,40.24656462522648;
2;2,11.40284147576970,210.99243904272370;2,6.50491457512741,30.82987222347189;
2;2,10.79267544476592,101.03360986818583;2,4.48539588858540,14.81363987308751;
include,../generate/Ag-aug-cc-pCVDZ.basis
}


geometry={
    1
    Ag atom
    Ag 0.0 0.0 0.0
}
{rhf;
 start,atden;
 print,orbitals=2;
 wf,19,1,1;
 occ,4,1,1,1,1,1,1,0;
 open,4.1
 sym,1,1,3,2,1
}
Ag_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;thresh,coeff=1d-3,energy=1d-5;core}
Ag_ccsd=energy



basis={
ecp,Ag,28,3,0;
4;1,11.11699601755791,19.0;3,11.30706740194795,211.222924333600290;2,10.88746528420199,-111.38567369335220;2,6.05089592989141,-10.04923439650254;
2;2,12.57067724180113,281.00441811099660;2,7.07522814100377,40.24656462522648;
2;2,11.40284147576970,210.99243904272370;2,6.50491457512741,30.82987222347189;
2;2,10.79267544476592,101.03360986818583;2,4.48539588858540,14.81363987308751;
include,../generate/Ag-aug-cc-pCVDZ.basis
}



!These are the wf cards parameters
ne = 38
symm = 1
ss= 0

!There are irrep cards paramters
!A1=6
!B1=2
!B2=2
!A2=1


geometry={
    2
    Ag2 molecule
    Ag 0.0 0.0 0.0
    Ag 0.0 0.0 2.30
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
! occ,A1,B1,B2,A2
! closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ag_ccsd-Ag_ccsd


table,2.30,scf,ccsd,bind
save
type,csv

