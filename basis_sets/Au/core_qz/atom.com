***,Au
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Au 0.0 0.0 0.0
}

!!! Initial guesses from STU
s_par=[1.234000,0.772300]
p_par=[2.693700,1.685700]
d_par=[3.714900,1.692000]
f_par=[2.577400]
g_par=[3.036800]
h_par=[1.267200]
proc opt_basis

basis={
include, ecp.molpro
include, basis.molpro

s,Au,s_par(1),s_par(2)
p,Au,p_par(1),p_par(2)
d,Au,d_par(1),d_par(2)
f,Au,f_par(1)
g,Au,g_par(1)
h,Au,h_par(1)
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

{minimize,eval, s_par(1),s_par(2),p_par(1),p_par(2),d_par(1),d_par(2),f_par(1),g_par(1),h_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

