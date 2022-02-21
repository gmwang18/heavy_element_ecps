***,Bi
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Bi 0.0 0.0 0.0
}

!!! Initial guesses from BFD
s_par=[0.106821, 2.8335]
p_par=[0.080749, 5.1786]
d_par=[0.202607, 1.5000]
f_par=[0.300000, 3.0000]

proc opt_basis

!Calculate the exponents
N=2   ! Adjust to get enough exponents
do i=1,N
s_exp(i)=s_par(1)*s_par(2)^(i-1)
p_exp(i)=p_par(1)*p_par(2)^(i-1)
d_exp(i)=d_par(1)*d_par(2)^(i-1)
f_exp(i)=f_par(1)*f_par(2)^(i-1)
enddo

basis={
include, ecp.molpro
include, basis.molpro

s,Bi,s_exp(1),s_exp(2)
p,Bi,p_exp(1),p_exp(2)
d,Bi,d_exp(1),d_exp(2)
f,Bi,f_exp(1)

}

{rhf
 start,atden
 wf,5,8,3
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0,0
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0,0
 wf,5,8,3;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,5,8,3
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0,0
 print,orbitals=2
}
data,rename,4202.2,4302.2
data,rename,5202.2,5302.2

{uccsd(t);maxit,100;core}
eval=energy

endproc

{minimize,eval,s_par(1),s_par(2),p_par(1),p_par(2),d_par(1),d_par(2),f_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

