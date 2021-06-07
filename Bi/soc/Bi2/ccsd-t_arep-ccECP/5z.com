***,Calculation of binding energy
memory,512,m
gthresh,twoint=1.0E-12

basis={
include, ecp.pp
include, aug-cc-pV5Z.basis
}

ne    =10
symm  =1
ss    =0

do i=1,7
    z(i) = 2.35 + 0.10*(i-1)
    geometry={
        2
        Bi2
        Bi  0.0 0.0 0.0
        Bi  0.0 0.0 z(i)
    }
    {rhf
     wf,nelec=ne ,spin=ss ,sym=symm
     !print,orbitals=3
    }
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {uccsd(t),shifts=0.4,shiftp=0.4;maxit,100;core}
    ccsd(i)=energy
enddo

basis={
include, ecp.pp
include, aug-cc-pV5Z.basis
}

geometry={
   1
   Bi
   Bi 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,5,8,3
 occ,1,1,1,0,1,0,0,0
 !open,1.3
 closed,1,0,0,0,0,0,0,0
 !sym,
}
A_scf=energy
B_scf=energy
_CC_NORM_MAX=2.0
{uccsd(t);maxit,100;core}
A_ccsd=energy
B_ccsd=energy

table,z,scf,ccsd, A_scf,A_ccsd,B_scf,B_ccsd
save, 5z.csv, new

