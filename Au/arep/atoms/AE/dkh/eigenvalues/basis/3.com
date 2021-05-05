***,Calculation for Au atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

geometry={
1
Au
Au  0.0 0.0 0.0
}

set,dkroll=1,dkho=10,dkhp=4

include,states.proc

do i=1,1
    if (i.eq.1) then
        5s
    !else if (i.eq.2) then
    !    5p
    !else if (i.eq.3) then
    !    5d
    !else if (i.eq.4) then
    !    5f
    endif
    scf(i)=energy
enddo

table,scf
save, 3.csv,new
