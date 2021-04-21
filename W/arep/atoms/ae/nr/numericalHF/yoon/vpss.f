	subroutine vpss (r,vs,vp,vloc)
	parameter (ncfd=500,lpp=6,ipp=10,nppd=4)
	implicit double precision (a-h,o-z)
	dimension sv(ncfd,nppd,4),sl(ncfd,4)
	dimension m(lpp),ns(ipp,lpp),es(ipp,lpp),c(ipp,lpp)
	save
	data init,rrmaxv,stepkr,vptres /0, 20., .05, 1.e-05/
c
	if (init.eq.0)	         			    then
	open(9,file='pp.d',form='formatted',status='old')
		do 100 ip=1,4
		do 100 iv=1,ncfd
		sl(iv,ip)=0.
 100		continue
		do 110 in=1,2
		do 110 ip=1,4
		do 110 iv=1,ncfd
		sv(iv,in,ip)=0.
 110		continue
c
	read (9,*) zion,ncoefl,stepvl,rcutvl
c	if (ncoefl.le.lpp)  call erm (' ncoefl <= lpp ')
c	if (ncoefl.gt.ncfd) call erm (' ncoefl > ncfd ')
		do 120 mc=1,ncoefl
		read (9,*) xdummy,(sl(mc,k),k=1,4)
 120		continue
	read (9,*) nvps
c	if (nvps.gt.nppd)   call erm (' nvps > nppd ')
	 	do 150 ivps=1,nvps
		read (9,*) ncoefv,stepvs,rcutvs
c		if (ncoefv.gt.ncfd)  call erm (' ncoefv > ncfd ')	
		do 135 mc=1,ncoefv
		read (9,*) xdummy,(sv(mc,ivps,k),k=1,4)
 135		continue
 150		continue
	write (*,*) ' spline coef. of nonl. pp entered  z=',zion
	init=1
	write (*,*) ' stepvs l ',stepvs,stepvl
	write (*,*) ' rcuts l ',rcutvs,rcutvl
							   endif
c	
	vs=0.
	vp=0.
	if (r.gt.rcutvl)			then
		vloc=-zion/r
						else
c	write (*,*) r,stepvl
	j=int(r/stepvl)+1
	vloc=sl(j,1)+r*(sl(j,2)+r*(sl(j,3)+r*sl(j,4)))
c	write (*,*) ' j r vloc ',j,r,vloc
						endif
	if (r.gt.rcutvs)			return
	vs=sv(j,1,1)+r*(sv(j,1,2)+r*(sv(j,1,3)+r*sv(j,1,4)))
	vp=sv(j,2,1)+r*(sv(j,2,2)+r*(sv(j,2,3)+r*sv(j,2,4)))
						return
	end
