***,W
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

W 0.0 0.0 0.0
}

basis={
include, ecp.molpro
include, basis.molpro   ! Optimal exponents for HF
}

{rhf
 start,atden
 print,orbitals=2
 wf,14,1,4
 occ,3,1,1,1,1,1,1,0
 closed,2,1,1,0,1,0,0,0
 sym,1,1,1,3,2
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,4,1,1,1,1,1,1,0
 closed,2,1,1,0,1,0,0,0
 wf,14,1,4;state,2
 wf,14,4,4;state,1
 wf,14,6,4;state,1
 wf,14,7,4;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,14,1,4
 occ,3,1,1,1,1,1,1,0
 closed,2,1,1,0,1,0,0,0
}
{ci;maxit,100;core,1,1,1,0,1,0,0,0
 natorb,ci,print=15

}