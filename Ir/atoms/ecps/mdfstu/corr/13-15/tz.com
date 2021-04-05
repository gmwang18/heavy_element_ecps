***, Calculation for Ir groundstate
memory,1024,m
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15
gthresh,throrth=1.8E-8
!symmetry,nosym

!set,dkroll=1,dkho=10,dkhp=4

basis={
ECP,Ir,60,5,0;
1; 2,1.000000,0.000000; 
2; 2,13.831474,426.958149; 2,7.047914,65.338813; 
4; 2,11.106433,88.075442; 2,10.456552,176.124770; 2,6.379614,12.682260; 2,5.064726,24.635949; 
4; 2,7.548754,46.433258; 2,7.265308,69.638074; 2,3.800969,6.150248; 2,3.718280,9.463560; 
2; 2,3.098706,9.483610; 2,3.049461,12.642742; 
2; 2,4.969790,-10.410697; 2,4.935614,-12.863196;
include,Ir-aug-cc-pwCVTZ.basis
}

geometry={
	1
	Iridium
	Ir 0.0 0.0 0.0
}

include,states.proc

do i=13,15

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
        {rccsd(t);maxit,100;core}
        ccsd(i)=energy
enddo



table,scf,ccsd
save
type,csv
