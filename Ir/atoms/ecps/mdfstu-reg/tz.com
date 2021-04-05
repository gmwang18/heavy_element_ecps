***, Calculation for Ir groundstate
memory,512,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
!symmetry,nosym

!set,dkroll=1,dkho=10,dkhp=4

basis={
ECP,Ir,60,4,0;
4
1, 12.37500, 17.0
3, 12.37500, 210.375
2, 12.37500, -143.136
2, 4.950858, -23.27387
2
2, 5.979993, 76.530807
2, 13.70714, 438.94528
2
2, 10.65963, 266.24649
2, 5.159463, 58.541082
2
2, 7.301644, 123.07298
2, 4.118530, 31.882903
2
2, 3.098706, 9.483610
2, 3.049461, 12.642742
include,tz.basis 
}

geometry={
	1
	Iridium
	Ir 0.0 0.0 0.0
}


include,states.proc

do i=1,15

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
		IVd6
	else if(i.eq.9) then
		Vd5
	else if(i.eq.10) then
		VId4
	else if(i.eq.11) then
		VIId3
	else if(i.eq.12) then
		VIIId2
	else if(i.eq.13) then
		IXd1
	else if(i.eq.14) then
		X
	else if(i.eq.15) then
		XVI
	endif
	scf(i)=energy
	_CC_NORM_MAX=2.0
        {rccsd(t),shifts=0.2,shiftp=0.2,thrdis=0.2;diis,1,1,15,1;maxit,100;core}
        ccsd(i)=energy
enddo



table,scf,ccsd
save
type,csv
