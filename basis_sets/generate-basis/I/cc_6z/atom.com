***,I
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

I 0.0 0.0 0.0
}

!!! Initial guesses 
s_par=[0.092871, 2.519469]
p_par=[0.069215, 2.199010]
d_par=[0.150685, 1.900672]
f_par=[0.188312, 2.144895]
g_par=[0.335616, 2.288031]
h_par=[0.483566, 2.388070]
i_par=[0.701216, 3.0]

proc opt_basis

!Calculate the exponents
N=5   ! Adjust to get enough exponents
do i=1,N
s_exp(i)=s_par(1)*s_par(2)^(i-1)
p_exp(i)=p_par(1)*p_par(2)^(i-1)
d_exp(i)=d_par(1)*d_par(2)^(i-1)
f_exp(i)=f_par(1)*f_par(2)^(i-1)
g_exp(i)=g_par(1)*g_par(2)^(i-1)
h_exp(i)=h_par(1)*h_par(2)^(i-1)
i_exp(i)=i_par(1)*i_par(2)^(i-1)
enddo

basis={
include, ecp.molpro
include, basis.molpro

s,I,s_exp(1),s_exp(2),s_exp(3),s_exp(4),s_exp(5)
p,I,p_exp(1),p_exp(2),p_exp(3),p_exp(4),p_exp(5)
d,I,d_exp(1),d_exp(2),d_exp(3),d_exp(4),d_exp(5)
f,I,f_exp(1),f_exp(2),f_exp(3),f_exp(4)
g,I,g_exp(1),g_exp(2),g_exp(3)
h,I,h_exp(1),h_exp(2)
i,I,i_exp(1)

}

{rhf
 start,atden
 wf,7,5,1
 occ,1,1,1,0,1,0,0,0
 closed,1,1,1,0,0,0,0,0
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0,0
 wf,7,2,1;state,1
 wf,7,3,1;state,1
 wf,7,5,1;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,7,5,1
 occ,1,1,1,0,1,0,0,0
 closed,1,1,1,0,0,0,0,0
 print,orbitals=2
}
data,rename,4202.2,4302.2
data,rename,5202.2,5302.2

{uccsd(t);maxit,100;core}
eval=energy

endproc

{minimize,eval,s_par(1),s_par(2),p_par(1),p_par(2),d_par(1),d_par(2),f_par(1),f_par(2),g_par(1),g_par(2),h_par(1),h_par(2),i_par(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

