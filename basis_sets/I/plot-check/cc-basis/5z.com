***,I
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

I 0.0 0.0 0.0
}


basis={
include, ecp.molpro
include, ../../basis/I.cc-pV5Z.molpro
}

{rhf
 start,atden
 wf,7,5,1
 occ,1,1,1,0,1,0,0,0
 closed,1,1,1,0,0,0,0,0
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0,0
 wf,7,2,1;state,1
 wf,7,3,1;state,1
 wf,7,5,1;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,7,5,1
 occ,1,1,1,0,1,0,0,0
 closed,1,1,1,0,0,0,0,0
 print,orbitals=2
}
scf(1)=energy
{uccsd(t);maxit,100;core}
ccsd(1)=energy


table,scf,ccsd
save
type,csv

