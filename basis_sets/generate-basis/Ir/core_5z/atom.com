***,Ir
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Ir 0.0 0.0 0.0
}

!!! Initial guesses from STU
s_par=[6.016700, 3.270000]
p_par=[5.373100, 3.361000]
d_par=[4.797400, 3.001200]
f_par=[3.232200]
g_par=[3.049400]
h_par=[2.779500]
i_par=[1.379600]
proc opt_basis

basis={
include, ecp.molpro
include, basis.molpro

s,Ir,s_par(1),s_par(2)
p,Ir,p_par(1),p_par(2)
d,Ir,d_par(1),d_par(2)
f,Ir,f_par(1)
g,Ir,g_par(1)
h,Ir,h_par(1)
i,Ir,i_par(1)
}

{rhf
 start,atden
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
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,17,1,3
 occ,4,1,1,1,1,1,1,0
 closed,4,1,1,0,1,0,0,0
 print,orbitals=2
}

data,rename,4202.2,4302.2
data,rename,4203.2,4303.2
data,rename,5202.2,5302.2

{ci;maxit,100;core}
eval=energy

endproc

{minimize,eval, s_par(1),s_par(2),p_par(1),p_par(2),d_par(1),d_par(2),f_par(1),g_par(1),h_par(1),i_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

