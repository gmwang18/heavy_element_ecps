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
f_par=[0.384700, 3.05666]
g_par=[0.957700, 3.00000]

proc opt_basis

!Calculate the exponents
N=2   ! Adjust to get enough exponents
do i=1,N
f_exp(i)=f_par(1)*f_par(2)^(i-1)
g_exp(i)=g_par(1)*g_par(2)^(i-1)
enddo

basis={
include, ecp.molpro
include, basis.molpro

f,Ir,f_exp(1),f_exp(2)
g,Ir,g_exp(1)

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

{ci;maxit,100;core,1,1,1,0,1,0,0,0}
eval=energy

endproc

{minimize,eval,f_par(1),f_par(2),g_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

