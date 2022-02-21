***,W
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

W 0.0 0.0 0.0
}

!!! Initial guesses from STU
s_par=[1.121828,1.075349]
p_par=[1.816808,1.008763]
d_par=[2.343229,0.695962]
f_par=[1.548224]
g_par=[1.205253]

proc opt_basis

basis={
include, ecp.molpro
include, basis.molpro

s,W,s_par(1),s_par(2)
p,W,p_par(1),p_par(2)
d,W,d_par(1),d_par(2)
f,W,f_par(1)
g,W,g_par(1)

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

data,rename,4202.2,4302.2
data,rename,5202.2,5302.2

{ci;maxit,100;core}
eval=energy

endproc

{minimize,eval, s_par(1),s_par(2),p_par(1),p_par(2),d_par(1),d_par(2),f_par(1),g_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

