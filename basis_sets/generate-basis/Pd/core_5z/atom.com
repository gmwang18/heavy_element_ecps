***,Pd
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Pd 0.0 0.0 0.0
}

!!! Initial guesses from STU
s_par=[1.650400,1.032300]
p_par=[2.029100,1.287900]
d_par=[1.124200,0.521200]
f_par=[8.328300]
g_par=[3.911400]
h_par=[3.782700]
i_par=[3.299100]

proc opt_basis

basis={
include, ecp.molpro
include, basis.molpro

s,Pd,s_par(1),s_par(2)
p,Pd,p_par(1),p_par(2)
d,Pd,d_par(1),d_par(2)
f,Pd,f_par(1)
g,Pd,g_par(1)
h,Pd,h_par(1)
i,Pd,i_par(1)
}

{rhf
 start,atden
 print,orbitals=2
 wf,18,1,0
 occ,3,1,1,1,1,1,1,0
 closed,3,1,1,1,1,1,1,0
 sym,1,1,3,2
 natorb,ci,print
 orbital,4202.2
}
{rhf,nitord=1,maxit=0
 start,4202.2
 wf,18,1,0
 occ,3,1,1,1,1,1,1,0
 closed,3,1,1,1,1,1,1,0
 sym,1,1,3,2
}

data,rename,4202.2,4302.2

{ci;maxit,100;core}
eval=energy

endproc

{minimize,eval, s_par(1),s_par(2),p_par(1),p_par(2),d_par(1),d_par(2),f_par(1),g_par(1),h_par(1),i_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

