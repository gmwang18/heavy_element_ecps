***,Calculation for Ag atom, singlet and triplet
memory,512,m
geometry={
1
Sr
Sr  0.0 0.0 0.0
}

basis={
ECP,Sr,28,4,0;
1; 2,1.,0.; 
2; 2,6.933460990,135.271042909; 2,4.114003832,17.944071402; 
4; 2,7.216816623,29.438081345; 2,7.173696172,58.880674863; 2,3.022798817,4.936282692; 2,2.865699030,9.723352071; 
4; 2,6.321514600,11.907239187; 2,6.391499495,17.859551440; 2,1.769726597,2.199180226; 2,1.636771665,2.893570866; 
2; 2,4.244198396,-5.509333254; 2,4.229164471,-7.304641693; 
include,aug-cc-pwCVQZ.basis
}

include,states.proc

do i=1,6
    if (i.eq.1) then
        I5s2
    else if (i.eq.2) then
        I5s5p
    else if (i.eq.3) then
        I5s4d
    else if (i.eq.4) then
        II5s1
    else if (i.eq.5) then
        II4d
    else if (i.eq.6) then
        III4p6
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
