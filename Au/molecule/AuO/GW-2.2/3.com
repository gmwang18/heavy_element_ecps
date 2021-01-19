***,Calculation of binding energy
memory,512,m
gthresh,twoint=1.0E-15

ne    =25
symm  =2
ss    =1

A1=6
B1=3
B2=3
A2=1

! Equilibrium geometry
geometry={
    2
    AuO
    Au 0.0 0.0 0.0
    O  0.0 0.0 1.9
}

basis={
include,Au.pp
include,Au_contracted.basis
include,O.pp
include,O_contracted.basis
}

{rhf
 wf,nelec=ne,spin=ss,sym=symm
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 orbital,2101.2
}

do i=1,8
    z(i) = 1.5 + 0.10*(i-1)
    geometry={
        2
        AuO
        Au  0.0 0.0 0.0
        O  0.0 0.0 z(i)
    }
    basis={
    include,Au.pp
    include,Au_aug-cc-pwCVTZ.basis
    include,O.pp
    include,O_aug-cc-pwCVTZ.basis
    }
    {rhf,maxdis=30,iptyp='DIIS',nitord=1,maxit=60; shift,-1.5,-1.0
     start,2101.2
     wf,nelec=ne,spin=ss,sym=symm
     occ,A1,B1,B2,A2
     closed,A1,B1-1,B2,A2
     orbital,ignore_error
    }
    !{mcscf
    ! occ,A1,B1,B2,A2
    ! closed,A1,B1-1,B2,A2
    ! wf,nelec=ne,spin=ss,sym=symm
    !}
    !{rhf,maxdis=30,iptyp='DIIS',nitord=1,maxit=100; shift,-1.5,-1.0
    ! wf,nelec=ne,spin=ss,sym=symm
    ! occ,A1,B1,B2,A2
    ! closed,A1,B1-1,B2,A2
    !}

    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t);maxit,100;core
     orbital,ignore_error
    }
    ccsd(i)=energy
enddo

geometry={
   1
   Au
   Au 0.0 0.0 0.0
}

basis={
include,Au.pp
include,Au_aug-cc-pwCVTZ.basis
}
{rhf
 start,atden
 print,orbitals=2
 wf,19,1,1
 occ,4,1,1,1,1,1,1,0
 open,4.1
 sym,1,1,3,2,1
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,4,1,1,1,1,1,1,0
 closed,3,1,1,1,1,1,1,0
 wf,19,1,1;state,1
 restrict,1,1,4.1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,19,1,1
 occ,4,1,1,1,1,1,1,0
 open,4.1
}

A_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
A_ccsd=energy

geometry={
   1
   O
   O 0.0 0.0 0.0
}

basis={
include,O.pp
include,O_aug-cc-pwCVTZ.basis
}
{rhf;
 start,atden
 wf,6,7,2;
 occ,1,1,1,0,1,0,0,0;
 open,1.3,1.5;
}

B_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
B_ccsd=energy

table,z,scf,ccsd, A_scf,A_ccsd,B_scf,B_ccsd
save, 3.csv, new

