***,Sc
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Sc 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/pps/Sc.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/basis/aug-cc-pVnZ/Sc_tz.basis
include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/basis/cc-pVnZ/Sc_tz.basis
}

{rhf
 start,atden
 wf,11,1,1
 occ,3,1,1,0,1,0,0,0
 open,3.1
 sym,1,1,1,2,3
 orbital,4202.2
}
{multi
 maxiter,40
 start,4202.2
 occ,4,1,1,1,1,1,1,0
 closed,2,1,1,0,1,0,0
 wf,11,1,1;state,2
 wf,11,4,1;state,1
 wf,11,6,1;state,1
 wf,11,7,1;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,11,4,1
 occ,2,1,1,1,1,0,0,0
 open,1.4
}

scf(i)=energy

_CC_NORM_MAX=2.0
{uccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,3.csv,new


