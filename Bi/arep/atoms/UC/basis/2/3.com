***,atomic
memory,1,g
gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

angstrom
geometry={
1

Bi  0.0 0.0 0.0
}

!basis={
!include,Bi_aug-cc-pwCVTZ.basis
!}

set,dkroll=1,dkho=10,dkhp=4
include,states.proc

do i=2,2
   if (i.eq.1) then
      st_s2p3
   else if (i.eq.2) then
      st_s2p4
   else if (i.eq.3) then
      st_s1p4
   else if (i.eq.4) then
      st_s2p2
   else if (i.eq.5) then
      st_s1p3
   else if (i.eq.6) then
      st_s2p1
   else if (i.eq.7) then
      st_s1p2
   else if (i.eq.8) then
      st_s2d1
   else if (i.eq.9) then
      st_s2f1
   else if (i.eq.10) then
      st_s2
   else if (i.eq.11) then
      st_s1p1
   else if (i.eq.12) then
      st_s1
   else if (i.eq.13) then
      st_p1
   else if (i.eq.14) then
      st_d1
   else if (i.eq.15) then
      st_f1
   else if (i.eq.16) then
      st_core
   end if
   scf(i)=energy
   _CC_NORM_MAX=2.0
   {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core,11,6,6,3,6,3,3,1}
   ccsd(i)=energy
enddo

table,scf,ccsd
save, 3.csv, new

