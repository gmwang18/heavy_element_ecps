***,Calculation for IrO groundstate
memory,1024,m

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
                                                                                !symmetry,nosym
basis={
include,Ir.pp
include,tz.basis

include,O.pp
include,O_aug-cc-CVTZ.basis
}

ne = 23

A1=6
B1=3
B2=3
A2=1

do i=1,1
        z(i) = 1.4 + 0.10*(i-1)
        geometry={
                2
                IrO
                Ir 0.0 0.0 0.0
                O 0.0 0.0 z(i)
        }
        {rhf,maxdis=35,iptyp='DIIS',nitord=30,maxit=60; shift,-1.0,-0.5
        wf,nelec=ne-3,spin=0,sym=1
        occ,A1,B1-1,B2-1,A2-1
        closed,A1,B1-1,B2-1,A2-1
        }
        {rhf,maxdis=35,iptyp='DIIS',nitord=30,maxit=60; shift,-1.0,-0.5
        wf,nelec=ne,spin=3,sym=1
        occ,A1,B1,B2,A2
        closed,A1,B1-1,B2-1,A2-1
        print,orbitals=2
        }
        scf(i)=energy
        {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core
	orbital,ignore_error}
        ccsd(i)=energy
enddo


geometry={
	1
	Iridium
	Ir 0.0 0.0 0.0
}

{rhf,maxdis=50,iptyp='DIIS',nitord=30,maxit=200; shift,-1.0,-0.5
 start,atden
 print,orbitals=2
 wf,17,1,3
 occ,4,1,1,1,1,1,1,0
 closed,4,1,1,0,1,0,0,0
 sym,1,1,1,3,2
 orbital,4202.2
}
pop
{multi
 start,4202.2
 maxit,40
 occ,4,1,1,1,1,1,1,0
 frozen,2,1,1,0,1,0,0
 wf,17,1,3;state,1
 wf,17,4,3;state,3
 wf,17,6,3;state,3
 wf,17,7,3;state,3
 natorb,ci,print
 orbital,4203.2
}
{multi
 start,4203.2
 maxit,40
 occ,4,1,1,1,1,1,1,0
 closed,2,1,1,0,1,0,0
 wf,17,1,3;state,1
 wf,17,4,3;state,3
 wf,17,6,3;state,3
 wf,17,7,3;state,3
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=100
 start,5202.2
 wf,17,1,3
 occ,4,1,1,1,1,1,1,0
 closed,4,1,1,0,1,0,0,0
 sym,1,1,1,3,2
}
A_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.3,shiftp=0.3,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
A_ccsd=energy  

geometry={
   1
   O
   O 0.0 0.0 0.0
}

basis={
include,O.pp
include,O_aug-cc-CVTZ.basis
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

