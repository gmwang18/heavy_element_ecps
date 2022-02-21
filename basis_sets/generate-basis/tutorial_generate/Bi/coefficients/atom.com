***,Bi
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Bi 0.0 0.0 0.0
}

basis={
include, ecp.molpro
include, basis.molpro   ! Optimal exponents for HF
}

{rhf
 start,atden
 wf,5,8,3
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0,0
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0,0
 wf,5,8,3;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,5,8,3
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0,0
 print,orbitals=2
}

