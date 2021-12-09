***,Mo
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Mo 0.0 0.0 0.0
}


basis={
include, ecp.molpro
include, cc-pwCVTZ.basis

}

{rhf
 start,atden
 wf,14,1,6
 occ,4,1,1,1,1,1,1,0
 closed,1,1,1,0,1,0,0,0
 sym,1,1,3,2,1
 restrict,1,1,4.1
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,4,1,1,1,1,1,1,0
 closed,1,1,1,0,1,0,0,0
 wf,14,1,6;state,1
 restrict,1,1,4.1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,14,1,6
 occ,4,1,1,1,1,1,1,0
 closed,1,1,1,0,1,0,0,0
 sym,1,1,3,2,1
 restrict,1,1,4.1
 print,orbitals=2
}

{ci;maxit,100;core
 natorb,ci,print=15

}


