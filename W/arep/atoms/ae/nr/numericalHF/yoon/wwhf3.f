	program ww
c
	parameter (nn=10000)
	dimension x(nn),y(nn),xx(nn),yy(nn)
	dimension sc(nn,4)
c
	open (1,file='fort.25',status='old',form='formatted')
	open (2,file='so.d',status='unknown',form='formatted')
c
	stepg=0.001
c
	read (1,*) nstate,zfull
	write (*,*)  ' zfull = ',zfull
	write (2,*) nstate
c
		do 800 ist=1,nstate
	iswitc=0
	write (*,*) ' rmax for state ',ist 
	read (*,*) rmax
	rmaxs=rmax
		read (1,*) nval,lstat
	write (*,*) ' l = ',lstat
		ymax=0.
		xxi=-1.
		i=0
		dismin=0.002
			do 100 ii=1,nval
c			read (1,*) idummy,x(i),y(i),up,upp
			read (1,*) idummy,xxn,yyn,up,upp
			if(xxn-xxi.lt.dismin)		go to 100 
			i=i+1
			x(i)=xxn
			y(i)=yyn
			xxi=xxn
			y(i)=y(i)/(x(i)**(lstat+1))
			ymax=amax1(ymax,abs(y(i)))
			write (*,*) i,x(i),y(i),ii
			if (x(i).gt.rmax.and.iswitc.eq.0) then
					imax=i-1
					rmax=x(imax)
					iswitc=1
						          endif
       				if (y(i).eq.0. .and.iswitc.eq.0)then
					imax=i-12
					rmax=x(imax)
					iswitc=1
							        endif
 100		continue
	write (*,*) ' r(1) rho(1) = ', x(1),y(1)
        write (*,*) ' actual rmax= ',rmax
     &    , '  R(rmax)= ', y(imax)*(x(imax)**lstat)
c
        ne0=1
	ne=ne0+5
        write (*,*) ne,ne0
	der0=(y(ne)-y(ne0))/(x(ne)-x(ne0))
	y0=y(ne0)+(0.-x(ne0))*der0
	write (*,*) y(ne0),y(ne),x(ne0),x(ne)
	write (*,*) ' orig der0 ',der0
	write (*,*) x(ne0),x(ne),y(ne0),y(ne)
	 derr0=float(lstat+1)*der0/y(ne0)
	write (*,*) ' der0 ', float(lstat+1)*der0/y(ne0)
	write (*,*) ' derivative at r=0 ? '
	read (*,*) der0
	der0=der0*y0/float(lstat+1)
	write (*,*) 'y0 ',y0 ,' is it ok (1/0)'
	read (*,*) icont 
	if (icont.eq.0) read (*,*) y0
        write (*,*) 'der0 ',der0 ,' is it ok (1/0)'
        read (*,*) icont 
        if (icont.eq.0) read (*,*) der0

        y(1)=y0
	x(1)=0.
c
c	extrapolation 
c
	imaxo=imax
	if (abs(rmaxs-x(imax)).gt.x(imax)-x(imax-1))	then
c
	write (*,*) ' exponential extrapolation '	
	derf=(y(imax+1)-y(imax-1))/(x(imax+1)-x(imax-1))
	write (*,*) y(imax+1),y(imax-1)
	write (*,*) x(imax+1),x(imax-1)
	write (*,*) derf
	af=y(imax)
	ae=-derf/af
	write (*,*) ' a0 = ',af, '   expon = ',ae
	if (ae.lt.0.)write (*,*) ' error expon is negative !'
		do 188 i=imax+1,nval
		y(i)=af*exp(-ae*(x(i)-x(imax)))
		if (x(i).gt.rmaxs)	go to 189
 188		continue
 189		imaxo=imax
		imax=i
							endif
	if (x(imax)-x(imaxo).lt.3.)			then
		do 193 j=1,nval
		if (x(imax)-x(j).le.3.)	go to 194
 193		continue
 194		imaxo=j	
							endif
c
c	smooth cutoff
c
	write (*,*) ' x(imax)',x(imax)
	ictt=ifix(x(imax)/stepg)
	x(imax)=float(ictt)*stepg
	write (*,*) ' x(imax)',x(imax)
	write (*,*) ' smooth cut-off within ',x(imaxo),x(imax)
	write (*,*) ' cut-off polyn. or gaussian ? (1/2)'
	read (*,*) ictf
	fac=x(imax)-x(imaxo)
	alfa=-alog(1.e-10)/(fac*fac)
	if (ictf.eq.2)	write (*,*) ' gauss. exp. = ',alfa
		do 195 j=1,nval
		if (j.ge.imaxo)	then
		xxx=x(j)-x(imaxo)
		zz=xxx/fac
		rmul=1.-zz*zz*(6.-8.*zz+3.*zz*zz)
		if (ictf.eq.2)	rmul=exp(-alfa*xxx*xxx)
		y(j)=y(j)*rmul
				endif
 195		continue
c
	rmax=x(imax)
	n=imax
	ne=1
	dern1=(y(n-ne)-y(n))/(x(n-ne)-x(n))
	dern2=(y(ne+n)-y(n))/(x(n+ne)-x(n))
	bbb=(dern2-dern1)/(x(n+ne)-x(n-ne))
	dern=(dern1-bbb*(x(n-ne)-x(n)))
	if (ictf.eq.1)	dern=0.
	write (*,*) '   x(n), y(n) dern ', x(n),y(n),dern
c 
cdbx
	do i=1,n
	write (*,*) x(i),y(i)
	enddo
			call spline (x,y,n,der0,dern,sc)
c
	ngrid=ifix(rmax/stepg)+1
		write (*,*) ' number of grid points = ', ngrid
c
c
		do 200 j=1,ngrid
		xx(j)=float(j-1)*stepg
		call splint (n,xx(j),yy(j),yd,ydd)
		if (j.eq.1)	yd0=yd	
		if (j.eq.ngrid) ydn=yd
	if (j.gt.ngrid-4)			then
		if (yy(j).lt.0.) yy(j)=abs(yy(j))
						endif
	if (ictf.eq.1 .and. j.eq.ngrid)		then
	write (*,*) ' icont interp. yy yyd (imax)',yy(j),yd
	read (*,*) icont
	yy(ngrid)=0.
	ydn=0.
						endif
 200		continue
		write (*,*) ' last val der. ', yy(ngrid),yd
c
			call splin1 (xx,yy,ngrid,yd0,ydn,sc)
c
c	check of the spline
c
	ngrid1=ngrid
	if (ictf.eq.2) ngrid1=ngrid-1
		write (2,*) ngrid1,stepg,xx(ngrid1)
		do 300 j=1,ngrid1
		write (2,*) xx(j),(sc(j,k),k=1,4)
 300		continue
c
 800	continue
c
	close (2)
	close (1)
c
					stop
	end
c		
	subroutine spline (xr,yr,n,yp1r,ypnr,splcr)
c
c	yp1>1.e+30 -> natural spline
c
	implicit double precision (a-h,o-z)
	parameter (nmax=12000,nn=12000)
        common /spl/ splcc(nn,4),x(nn),y(nn) 
	real xr,yr,yp1r,ypnr,splcr
	dimension xr(nn),yr(nn),splcr(nn,4)
	dimension y2(nmax),u(nmax)
c
	yp1=dble(yp1r)
	ypn=dble(ypnr)
		do 10 i=1,n
		x(i)=dble(xr(i))
		y(i)=dble(yr(i))
 10		continue
c
	if (yp1.gt. .99d+30)	then
		y2(1)=0.d+00
		u(1)=0.d+00
				else
		y2(1)=-.5d+00
	u(1)=(3.d+00/(x(2)-x(1)))*((y(2)-y(1))/(x(2)-x(1))-yp1)
				endif
c
		do 11 i=2,n-1
		sig=(x(i)-x(i-1))/(x(i+1)-x(i-1))
		p=sig*y2(i-1)+2.d+00
		y2(i)=(sig-1.d+00)/p
	u(i)=(6.d+00*((y(i+1)-y(i))/(x(i+1)-x(i))-(y(i)-y(i-1))
     &	     /(x(i)-x(i-1)))/(x(i+1)-x(i-1))-sig*u(i-1))/p	
 11		continue
c
	if (ypn.gt. .99d+30)	then
		qn=0.d+00
		un=0.d+00
				else
		qn=0.5d+00
	un=(3.d+00/(x(n)-x(n-1)))*(ypn-(y(n)-y(n-1))/(x(n)-x(n-1)))
				endif
c
	y2(n)=(un-qn*u(n-1))/(qn*y2(n-1)+1.d+00)
		do 12 k=n-1,1,-1
		y2(k)=y2(k)*y2(k+1)+u(k)
 12		continue
c
		do 20 i=1,n-1
		hi=x(i+1)-x(i)
		c0=(x(i+1)*y(i)-x(i)*y(i+1))/hi+hi*(y2(i+1)*x(i)-
     &	           x(i+1)*y2(i))/6.d+00 +(x(i+1)**3*y2(i)-
     &		   x(i)**3*y2(i+1))/(6.d+00*hi)
		c1=(y(i+1)-y(i))/hi+hi*(y2(i)-y2(i+1))/6.d+00+
     &		   (x(i)**2*y2(i+1)-y2(i)*x(i+1)**2)/(2.d+00*hi)
		c2=(x(i+1)*y2(i)-x(i)*y2(i+1))/(2.d+00*hi)
		c3=(y2(i+1)-y2(i))/(6.d+00*hi)
c
		splcr(i,1)=sngl(c0)
		splcr(i,2)=sngl(c1)
		splcr(i,3)=sngl(c2)
		splcr(i,4)=sngl(c3)
		splcc(i,1)=c0
		splcc(i,2)=c1
		splcc(i,3)=c2
		splcc(i,4)=c3
c
 20		continue
						return
	end
c
	subroutine splint (n,xr,yr,ydr,yddr)
	implicit double precision (a-h,o-z)
	real xr,yr,ydr,yddr
c
	parameter (nn=12000)
	common /spl/ sc(nn,4),xa(nn),ya(nn)
c
	x=dble(xr)
	if (x.lt.xa(1).or.x.gt.xa(n))		then
	write (*,*) ' splint err. -> interval ',x,xa(1),xa(n)
						return 
						endif
	klo=1
	khi=n
	
 1	if (khi-klo.gt.1)			then
		k=(khi+klo)/2
		if (xa(k).gt.x)		then
			khi=k
					else
			klo=k
					endif
						go to 1
						endif
c
	h=xa(khi)-xa(klo)
	j=klo
	xsc4=x*sc(j,4)
	yr=sngl(sc(j,1)+x*(sc(j,2)+x*(sc(j,3)+xsc4)))
	sc32=2.d+00*sc(j,3)
	ydr=sngl(sc(j,2)+x*(sc32+3.*xsc4))
	ydd=sngl(sc32+6.d+00*xsc4)
						return
	end
c
	subroutine splino (step,sc,n,x,y,yd,ydd)
c
	parameter (nn=12000)
	dimension sc(nn,4)
c
	j=int(x/step)+1
c
	sc2=sc(j,2)
	sc3=sc(j,3)
	xsc4=x*sc(j,4)
	y=sc(j,1)+x*(sc2+x*(sc3+xsc4))
	sc32=2.*sc3
	yd=sc2+x*(sc32+3.*xsc4)
	ydd=sc32+6.*xsc4
c
						return
	end
	subroutine splin1 (xr,yr,n,yp1r,ypnr,splcr)
c
c	input: xr(i),yr(i),i=1,n  
c       input: yp1r=deriv. at xr(1),ypnr=deriv. at xr(n)
c              (yp1r,ypnr > 1.e+30 for the natural spline)
c
c	output: splcr(n,5) (to be used with splint or splinr)
c
	implicit double precision (a-h,o-z)
	real xr,yr,yp1r,ypnr,splcr
	parameter (nmax=12000,nn=12000)
	dimension xr(nn),yr(nn),splcr(nn,4)
	dimension x(nmax),y(nmax),y2(nmax),u(nmax)
c
		do 1 j=1,4
		do 1 i=1,nn
		splcr(i,j)=0.
 1		continue
	yp1=dble(yp1r)
	ypn=dble(ypnr)
		do 10 i=1,n
		x(i)=dble(xr(i))
		y(i)=dble(yr(i))
 10		continue
c
	if (yp1.gt. .99d+30)	then
		y2(1)=0.d+00
		u(1)=0.d+00
				else
		y2(1)=-.5d+00
	u(1)=(3.d+00/(x(2)-x(1)))*((y(2)-y(1))/(x(2)-x(1))-yp1)
				endif
c
		do 11 i=2,n-1
		sig=(x(i)-x(i-1))/(x(i+1)-x(i-1))
		p=sig*y2(i-1)+2.d+00
		y2(i)=(sig-1.d+00)/p
	u(i)=(6.d+00*((y(i+1)-y(i))/(x(i+1)-x(i))-(y(i)-y(i-1))
     &	     /(x(i)-x(i-1)))/(x(i+1)-x(i-1))-sig*u(i-1))/p	
 11		continue
c
	if (ypn.gt. .99d+30)	then
		qn=0.d+00
		un=0.d+00
				else
		qn=0.5d+00
	un=(3.d+00/(x(n)-x(n-1)))*(ypn-(y(n)-y(n-1))/(x(n)-x(n-1)))
				endif
c
	y2(n)=(un-qn*u(n-1))/(qn*y2(n-1)+1.d+00)
		do 12 k=n-1,1,-1
		y2(k)=y2(k)*y2(k+1)+u(k)
 12		continue
c
		do 20 i=1,n
		splcr(i,1)=xr(i)
		splcr(i,1)=yr(i)
		if (i.lt.n)			then
		hi=x(i+1)-x(i)
		c1=(y(i+1)-y(i))/hi-hi*(2.*y2(i)+y2(i+1))/6.
		c2=y2(i)/2.
		c3=(y2(i+1)-y2(i))/(6.*hi)
		splcr(i,2)=sngl(c1)
		splcr(i,3)=sngl(c2)
		splcr(i,4)=sngl(c3)
						endif
c
 20		continue
						return
	end
c
