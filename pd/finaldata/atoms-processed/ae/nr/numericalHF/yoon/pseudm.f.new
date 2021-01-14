	subroutine pseudm (rr,vs,vp,vloc)
	implicit double precision(a-h,o-z)
	real*4 vss,vps,vls,rs,rcuts,zeffs
	character*1 dum1
 	parameter (max=3000)
	dimension r(max),v(max,3)
	data init/0/
c
	if (init.eq.0)		then
	open(unit=91,file='ppm.d',status='old',form='formatted')
854 	format(a1)
	read (91,*) n,rcuts,zeffs,rydbg 
cdbx	write (*,*)  n,rcuts,zeffs,rydbg
	read (91,854) dum1
	read (91,854) dum1
	read (91,854) dum1
	rcut=dble(rcuts)
	zeff=dble(zeffs)
	do i=1,n
	read (91,*) rs,vss,vps,vls
cdbx
	r(i)=dble(rs)
	v(i,1)=dble(vss)*rydbg
	v(i,2)=dble(vps)*rydbg
	v(i,3)=dble(vls)*rydbg
	if (r(i).gt.rcut+.2)			go to 100
	enddo
c
100	continue
	nn=i-1
	do j=1,3
	do i=1,nn
	write (92,*) r(i),v(i,j)
	enddo
	write (92,*) '1.0  +20.0'
	write (92,*) '0.0  +20.0'
	enddo
				init=1
				endif
c
	if (rr.gt.rcut)		then
	vloc=-zeff/rr
	vs=vloc
	vp=vloc
				return
				endif
	do k=nn,1,-1
	if (rr.gt.r(k))		go to 200
	enddo
	vloc=v(1,3)
	vs=v(1,1)
	vp=v(1,2)
				return
200	continue
	vloc=v(k,3)+(rr-r(k))*(v(k+1,3)-v(k,3))/(r(k+1)-r(k))
	vs  =v(k,1)+(rr-r(k))*(v(k+1,1)-v(k,1))/(r(k+1)-r(k))
	vp  =v(k,2)+(rr-r(k))*(v(k+1,2)-v(k,2))/(r(k+1)-r(k))
				return
	end
