***,Te
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Te 0.0 0.0 0.0
}

!!! Tenitial guesses 
s_par=[0.10, 2.5]
p_par=[0.08, 2.5]
d_par=[0.18, 2.5]
f_par=[0.22, 2.5]
g_par=[0.45, 2.5]
h_par=[0.60, 3.0]

proc opt_basis

!Calculate the exponents
N=4   ! Adjust to get enough exponents
do i=1,N
s_exp(i)=s_par(1)*s_par(2)^(i-1)
p_exp(i)=p_par(1)*p_par(2)^(i-1)
d_exp(i)=d_par(1)*d_par(2)^(i-1)
f_exp(i)=f_par(1)*f_par(2)^(i-1)
g_exp(i)=g_par(1)*g_par(2)^(i-1)
h_exp(i)=h_par(1)*h_par(2)^(i-1)
enddo

basis={
include, ecp.molpro
include, basis.molpro

s,Te,s_exp(1),s_exp(2),s_exp(3),s_exp(4)
p,Te,p_exp(1),p_exp(2),p_exp(3),p_exp(4)
d,Te,d_exp(1),d_exp(2),d_exp(3),d_exp(4)
f,Te,f_exp(1),f_exp(2),f_exp(3)
g,Te,g_exp(1),g_exp(2)
h,Te,h_exp(1)

}

{rhf
 start,atden
 wf,6,4,2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,1,0,0,0
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0,0
 wf,6,4,2;state,1
 wf,6,6,2;state,1
 wf,6,7,2;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,6,4,2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,1,0,0,0
 print,orbitals=2
}
data,rename,4202.2,4302.2
data,rename,5202.2,5302.2

{uccsd(t);maxit,100;core}
eval=energy

endproc

{minimize,eval,s_par(1),s_par(2),p_par(1),p_par(2),d_par(1),d_par(2),f_par(1),f_par(2),g_par(1),g_par(2),h_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

