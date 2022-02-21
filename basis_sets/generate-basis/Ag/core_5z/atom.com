***,Ag
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Ag 0.0 0.0 0.0
}

!!! Initial guesses from STU
s_par=[1.531950,1.322756]
p_par=[2.866662,3.305945]
d_par=[6.011544,2.666931]
f_par=[3.276046]
g_par=[3.815924]
h_par=[3.898123]
i_par=[2.059805]
proc opt_basis

basis={
include, ecp.molpro
include, basis.molpro

s,Ag,s_par(1),s_par(2)
p,Ag,p_par(1),p_par(2)
d,Ag,d_par(1),d_par(2)
f,Ag,f_par(1)
g,Ag,g_par(1)
h,Ag,h_par(1)
i,Ag,i_par(1)
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
 sym,1,1,3,2,1
}

data,rename,4202.2,4302.2
data,rename,5202.2,5302.2

{ci;maxit,100;core}
eval=energy

endproc

{minimize,eval, s_par(1),s_par(2),p_par(1),p_par(2),d_par(1),d_par(2),f_par(1),g_par(1),h_par(1),i_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

