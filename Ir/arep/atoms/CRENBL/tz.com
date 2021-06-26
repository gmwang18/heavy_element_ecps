***, Calculation for Ir groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
!symmetry,nosym

!set,dkroll=1,dkho=10,dkhp=4

basis={
include,crenbl
include,tz.basis 
}

geometry={
	1
	Iridium
	Ir 0.0 0.0 0.0
}


include,states.proc

do i=8,11

        if(i.eq.1) then
                Is2d7
        else if(i.eq.2) then
                Is1d8
        else if(i.eq.3) then
                Id9
        else if(i.eq.4) then
                IIs1d7
        else if(i.eq.5) then
                IId8
        else if(i.eq.6) then
                As2d8
        else if(i.eq.7) then
                IIId7
        else if(i.eq.8) then
                IIId5s1p1
        else if(i.eq.9) then
                IVd6
        else if(i.eq.10) then
                IVd5p1
        else if(i.eq.11) then
                Vd5
        else if(i.eq.12) then
                VId4
        else if(i.eq.13) then
                VIId3
        else if(i.eq.14) then
                VIIId2
        else if(i.eq.15) then
                IXd1
        else if(i.eq.16) then
                IXf
        else if(i.eq.17) then
                X
        else if(i.eq.18) then
                XVI

	endif
	scf(i)=energy
        _CC_NORM_MAX=2.0
        {rccsd(t);maxit,100;core}
        ccsd(i)=energy
enddo

!,shifts=0.2,shiftp=0.2,thrdis=0.2;diis,1,1,15,1

table,scf,ccsd
save
type,csv
