***,Mo
memory,512,m

gthresh,twoint=1.e-12
gprint,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Mo 0.0 0.0 0.0
}

!!! Initial guesses from BFD
f_par=[1.107047 , 2.50000]

proc opt_basis

!Calculate the exponents
N=1   ! Adjust to get enough exponents
do i=1,N
f_exp(i)=f_par(1)*f_par(2)^(i-1)
enddo

basis={
include, ecp.molpro
include, basis.molpro

f,Mo,f_exp(1)

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
 occ,4,1,1,1,1,1,1,0
 closed,1,1,1,0,1,0,0,0
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
data,rename,5202.2,5302.2

{uccsd(t);maxit,100;core}
eval=energy

endproc

{minimize,eval,f_par(1),f_par(2)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=1e-3
maxit,100}

