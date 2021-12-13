***,W
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

W 0.0 0.0 0.0
}

!!! Initial guesses from BFD
f_par=[0.130000, 2.181539]
g_par=[0.246500, 2.499800]
h_par=[0.422200, 2.774514]
i_par=[0.804800, 2.500000]

proc opt_basis

!Calculate the exponents
N=4   ! Adjust to get enough exponents
do i=1,N
f_exp(i)=f_par(1)*f_par(2)^(i-1)
g_exp(i)=g_par(1)*g_par(2)^(i-1)
h_exp(i)=h_par(1)*h_par(2)^(i-1)
i_exp(i)=i_par(1)*i_par(2)^(i-1)
enddo

basis={
include, ecp.molpro
include, basis.molpro

f,W,f_exp(1),f_exp(2),f_exp(3),f_exp(4)
g,W,g_exp(1),g_exp(2),g_exp(3)
h,W,h_exp(1),h_exp(2)
i,W,i_exp(1)

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

{uccsd(t);maxit,100;core}
eval=energy

endproc

{minimize,eval,f_par(1),f_par(2),g_par(1),g_par(2),h_par(1),h_par(2),i_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

