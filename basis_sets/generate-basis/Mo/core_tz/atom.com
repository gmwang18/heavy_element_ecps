***,Mo
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Mo 0.0 0.0 0.0
}

!!! Initial guesses from STU
s_par=[1.180890, 1.162284]
p_par=[2.705067, 0.932832]
d_par=[2.464011, 0.756019]
f_par=[2.784970]
g_par=[1.910183]

proc opt_basis

basis={
include, ecp.molpro
include, basis.molpro

s,Mo,s_par(1),s_par(2)
p,Mo,p_par(1),p_par(2)
d,Mo,d_par(1),d_par(2)
f,Mo,f_par(1)
g,Mo,g_par(1)

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
 maxit,40
 occ,4,1,1,1,1,1,1,0
 frozen,1,1,1,0,1,0,0
 wf,14,1,6;state,1
 orbital,4203.2
}
{multi
 start,4203.2
 maxit,40
 occ,4,1,1,1,1,1,1,0
 closed,1,1,1,0,1,0,0
 wf,14,1,6;state,1
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

data,rename,4202.2,4302.2
data,rename,4203.2,4303.2
data,rename,5202.2,5302.2

{ci;maxit,100;core}
eval=energy

endproc

{minimize,eval, s_par(1),s_par(2),p_par(1),p_par(2),d_par(1),d_par(2),f_par(1),g_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}
