      program fitgauss
c
c this program will read in the orbitals from a numerical
c hartree-fock calculation and fit a given set of gaussians
c to it by minimizing the area between the two curves
c NB: this is the original version, where EXP has the old
c format (uncompatible with Gamess format)
      implicit none
      integer i,imax,maxexp,maxgrid,nexp,ngrid,itmax,iex,
     &        igener,iter,ipqn,j,ne
      real*8 gexp,r,r2,c,pi,cnorm,feg2,fac,area,fi,fih,fii,
     &       grad,xm,epss,hh,dfn,fret,ftol,wei,alpha,rmax,c1,
     &       feg,dr,temp,fig,er,fmult
      parameter(imax=10000,maxexp=20,maxgrid=4000,pi=3.1415926535)
      dimension gexp(maxexp),fi(maxgrid),
     &          c(maxexp),grad(maxexp),xm(maxexp),cnorm(maxexp),
     &          wei(maxgrid),dr(maxgrid),temp(maxexp),r(maxgrid),
     &          fig(maxgrid,maxexp),r2(maxgrid)
      common /gas/ fig,dr,fi,wei,gexp,cnorm,c1,ngrid,nexp,ipqn,cmin
      character*1 otype,dum
      logical cmin
c
      cmin=.false.
      alpha=0.1
      igener=0
      iter=0  
      ftol=0.
      do 5 i=1,maxexp
        grad(i)=0.    
        xm(i)=1.      
 5    continue  

c
c get the exponents and compute normalizations
c
      write(*,*) 'enter orbital type (S,P,D):'
      read(*,*) otype
      if(otype.eq.'S')then
        ipqn=1
        write(*,*) 'constrain phi=0 at r=0 (y/n)'
        read(*,*) dum
        if(dum.eq.'y')cmin=.true.
      elseif(otype.eq.'P')then
        ipqn=2
      elseif(otype.eq.'D')then
        ipqn=3
      endif
      write(*,*) 'please enter the exponents (0=stop)'
      open(2,file='EXP')
      do i=1,maxexp
        read(2,*,end=7) temp(i+1),c(i+1)
        write(*,*) temp(i+1),c(i+1)
        if(temp(i+1).eq.0.)go to 7
      enddo
 7    continue
      close(2)
      nexp=i
      write(*,*) 'original number of exponents = ',nexp-1
      write(*,*) 'new exp = highest times ?'
      read(*,*) fmult
      temp(1)=temp(2)*fmult
      c(1)=0.001
      c1=0.0
      write(*,*) 'adding new exponent ',temp(1)
      do i=1,nexp
        fac=dsqrt(2.d0*temp(i)/pi)
        feg=4.d0*temp(i)
        feg2=feg*feg
        if(ipqn.eq.1)cnorm(i)=dsqrt(2.d0*feg*fac)
        if(ipqn.eq.2)cnorm(i)=dsqrt(2.d0*feg2*fac/3.d0)
        if(ipqn.eq.3)cnorm(i)=dsqrt(2.d0*feg*feg2*fac/15.d0)
      enddo
c for S keep the entered exponents as optimizing parameters
c and use the new one to fix
      if(otype.eq.'S'.and.cmin)then
        do i=1,nexp-1
          c(i)=c(i+1)
        enddo
      endif
      do i=1,nexp
        gexp(i)=temp(i)
      enddo
c
c read in the numerical orbital. always use filename=PHI
c for now don't read the splines, just read r,fi
c tabulate gaussian weights for the integral
c
      open(3,file='PHI')
      do i=1,maxgrid
        read(3,*,end=10) r(i),fi(i)
        r2(i)=r(i)*r(i)
      enddo
 10   continue
      close(3)
      ngrid=i-1
      write(*,*) '# grid points = ',ngrid
      rmax=r(ngrid)
      write(*,*) 'rmax=',rmax
      dr(1)=r(2)/2.d0
      do i=2,ngrid
        dr(i)=(r(i+1)-r(i-1))/2.d0
      enddo
      do i=1,ngrid
c       wei(i)=dexp(-alpha*r2(i))
        do j=1,nexp
          er=gexp(j)*r2(i)
          fig(i,j)=cnorm(j)*dexp(-er)*r(i)**(ipqn-1)
        enddo
        wei(i)=1.0
      enddo
c for S-type the first coefficient will be changed each
c time funct is called such that fi=0 at r=0
      call funct(c,area)        
      write(*,*) 'initial area=',area
c
c fit the gaussians in a least-squares sense, by minimizing
c the weighted integral over (phi-fi)**2
c
      epss=0.00001
      hh=0.001
      dfn=-.5         
      if(area.lt.1.E-3)then
        write(*,*) 'initial area small...changing opt steps'
        epss=epss/10000.0
        hh=hh/10000.0
      endif
      write(*,*) 'Maximum iterations in minimization?'
      read(*,*) itmax
c
c for an S-type orbital, we will keep the highest exponent fixed
c during optimization, then set it such that the sum is 0 at r=0
c try 5 iterations for now...may need more
c
      if(otype.eq.'S'.and.cmin)then
        write(*,*) 'nexp=',nexp
        write(*,*) 'S-type contrained minimization'
        call funct(c,area)
        write(*,*) 'check area=',area
        ne=nexp-1
        call va10a (ne,c,fret,grad,dfn,xm,hh,epss,1,itmax,1,iex)
        fii=0.
        do j=2,nexp
          fii=fii+c(j)*cnorm(j)
        enddo
        fih=cnorm(1)
        write(*,*) 'sum at zero = ',fii+fih*c1
      else
        call va10a (nexp,c,fret,grad,dfn,xm,hh,epss,1,itmax,1,iex)
      endif
c
      open(3,file='exp.out')
      if(otype.eq.'S'.and.cmin)then
        write(*,23) 1,gexp(1),c1
        write(3,23) 1,gexp(1),c1
        do i=2,nexp
          write(*,23) i,gexp(i),c(i-1)
          write(3,23) i,gexp(i),c(i-1)
        enddo
      else
        do i=1,nexp
          write(*,23) i,gexp(i),c(i)
          write(3,23) i,gexp(i),c(i)
        enddo
      endif
 23   format(i4,x,f10.4,x,f14.7)
      close(3)
      call funct(c,area)
      write(*,*) 'final area=',area
c
      end 


      subroutine funct(c,f)
      implicit none
      real*8 phi,gexp,fi,c,area,dr,y1,y2,sum,f,dy,cnorm,
     &       wei,c1,coef,sumz,fig
      integer i,j,maxgrid,ngrid,maxexp,ipqn,nexp
      parameter(maxgrid=4000,maxexp=20)
      dimension gexp(maxexp),fi(maxgrid),
     &          c(maxexp),phi(maxgrid),dr(maxgrid),cnorm(maxexp),
     &          wei(maxgrid),coef(maxexp),dr(maxgrid),
     &          fig(maxgrid,maxexp)
      common /gas/ fig,dr,fi,wei,gexp,cnorm,c1,ngrid,nexp,ipqn,cmin
      logical cmin
c
c computes integral: dr(phi-fi)**2
c
      sum=0.
      sumz=0.
      phi(1)=0.
      do i=2,ngrid
        phi(i)=0.
      enddo
c
      if(ipqn.eq.1.and.cmin)then
        do i=2,nexp
          coef(i)=c(i-1)
          sumz=sumz+coef(i)*cnorm(i)
        enddo
c reset the c1 coefficent for S
        c1=-sumz/cnorm(1)
        coef(1)=c1
      else
        do i=1,nexp
          coef(i)=c(i)
        enddo
      endif
      do j=1,nexp
        do i=1,ngrid
          phi(i)=phi(i)+coef(j)*fig(i,j)
        enddo
      enddo
c
c     do i=1,ngrid
c       sum=sum+dr(i)*phi(i)*phi(i)*r2(i)**ipqn
c     enddo
c     write(*,*) 'sum=',sum
c 
c integral
c
      area=0.
      do i=1,ngrid
        y1=dabs(phi(i-1)-fi(i-1))
        y2=dabs(phi(i)-fi(i))
        dy=(y2+y1)/2.d0
        area=area+dr(i)*wei(i)*dy*dy
      enddo
c
      f=area
c
      end


      subroutine va10a (n, x, f, g, dfn, xm,
     &  hh, eps, mode, maxfn, iprint, iexit)
	parameter (mparm=20)
      implicit double precision (a-h,o-z)
c this minimizes function of n variables x; from the Harwell library
c f is the best value.
c g is the  estimate of the gradient
c h is a real array of n(n+1)/2 elements
c w is an array of 4*n elements
      save  zero, half, one, two
      dimension x(mparm), g(mparm), h((mparm*(mparm+1))/2),
     &          w(4*mparm), xm(4*mparm)

      data zero, half, one, two /0.0, 0.5, 1.0, 2.0/
      if (iprint .ne. 0) write (6,1000)
 1000 format (' entry into va10a')
      np = n + 1
      n1 = n - 1
      nn=(n*np)/2
      is = n
      iu = n
      iv = n + n
      ib = iv + n
      idiff = 1
      iexit = 0
      if (mode .eq. 3) go to 15
      if (mode .eq. 2) go to 10
      ij = nn + 1
      do 5 i = 1, n
      do 6 j = 1, i
      ij = ij - 1
   6  h(ij) = zero
   5  h(ij) = one
      go to 15
  10  continue
      ij = 1
      do 11 i = 2, n
      z = h(ij)
      if (z .le. zero) return
      ij = ij + 1
      i1 = ij
      do 11 j = i, n
      zz = h(ij)
      h(ij) = h(ij) / z
      jk = ij
      ik = i1
      do 12 k = i, j
      jk = jk + np - k
      h(jk) = h(jk) - h(ik) * zz
      ik = ik + 1
  12  continue
      ij = ij + 1
  11  continue
      if (h(ij) .le. zero) return
  15  continue
      ij = np
      dmin = h(1)
      do 16 i = 2, n
      if (h(ij) .ge. dmin) go to 16
      dmin = h(ij)
  16  ij = ij + np - i
      if (dmin .le. zero) return
      z = f
      itn = 0
      write(*,*) (n,x(i),i=1,3)
      call funct (x, f)
      ifn = 1
      df = dfn
      if (dfn .eq. zero) df = f - z
      if (dfn .lt. zero) df = dabs (df * f)
      if (df .le. zero) df = one
  17  continue
      do 19 i = 1, n
      w(i) = x(i)
  19  continue
      link = 1
      if (idiff - 1) 100, 100, 110
  18  continue
      if (ifn .ge. maxfn) go to 90
  20  continue
c
c update log
c 
c     if (iprint .lt. 0) go to 21
      write (6,1001) itn, ifn,dsqrt(dabs(f)),f
1001  format (1x,'it= ',i4,' if = ',i4,' sf = ',f10.5,' f = ',f10.5)
  21  continue
      itn = itn + 1
      w(1) = -g(1)
      do 22 i = 2, n
      ij = i
      i1 = i - 1
      z = -g(i)
      do 23 j = 1, i1
      z = z - h(ij) * w(j)
      ij = ij + n - j
  23  continue
  22  w(i) = z
      w(is+n) = w(n) / h(nn)
      ij = nn
      do 25 i = 1, n1
      ij = ij - 1
      z = zero
      do 26 j = 1, i
      z = z + h(ij) * w(is+np-j)
      ij = ij - 1
  26  continue
  25  w(is+n-i) = w(n-i) / h(ij) - z
      z = zero
      gs0 = zero
      do 29 i = 1, n
      if (z * xm(i) .ge. dabs (w(is+i))) go to 28
      z = dabs (w(is+i)) / xm(i)
  28  gs0 = gs0 + g(i) * w(is+i)
  29  continue
      aeps = eps / z
      iexit = 2
      if (gs0 .ge. zero) go to 92
      alpha = -two * df / gs0
      if (alpha .gt. one) alpha = one
      ff = f
      tot = zero
      int = 0
      iexit = 1
  30  continue
      if (ifn .ge. maxfn) go to 90
      do 31 i = 1, n
      w(i) = x(i) + alpha * w(is+i)
  31  continue
      call funct (w, f1)
      ifn = ifn + 1
      if (f1 .ge. f) go to 40
      f2 = f
      tot = tot + alpha
  32  continue
      do 33 i = 1, n
      x(i) = w(i)
  33  continue
      f = f1
      if (int - 1) 35, 49, 50
  35  continue
      if (ifn .ge. maxfn) go to 90
      do 34 i = 1, n
      w(i) = x(i) + alpha * w(is+i)
  34  continue
      call funct (w, f1)
      ifn = ifn + 1
      if (f1 .ge. f) go to 50
      if ((f1 + f2 .ge. f + f) .and.
     $  (7.0d0 * f1 + 5.0d0 * f2 .gt. 12.0d0 * f)) int = 2
      tot = tot + alpha
      alpha = two * alpha
      go to 32
  40  continue
      if (alpha .lt. aeps) go to 92
      if (ifn .ge. maxfn) go to 90
      alpha = half * alpha
      do 41 i = 1, n
      w(i) = x(i) + alpha * w(is+i)
  41  continue
      call funct (w, f2)
      ifn = ifn + 1
      if (f2 .ge. f) go to 45
      tot = tot + alpha
      f = f2
      do 42 i = 1, n
      x(i) = w(i)
  42  continue
      go to 49
  45  continue
      z = 0.1d0
      if (f1 + f .gt. f2 + f2)
     $  z = one + half * (f - f1) / (f + f1 - f2 - f2)
      if (z .lt. 0.1d0) z = 0.1d0
      alpha = z * alpha
      int = 1
      go to 30
  49  continue
      if (tot .lt. aeps) go to 92
  50  continue
      alpha = tot
      do 56 i = 1, n
      w(i) = x(i)
      w(ib+i) = g(i)
  56  continue
      link = 2
      if (idiff - 1) 100, 100, 110
  54  continue
      if (ifn .ge. maxfn) go to 90
      gys = zero
      do 55 i = 1, n
      w(i) = w(ib+i)
      gys = gys + g(i) * w(is+i)
  55  continue
      df = ff - f
      dgs = gys - gs0
      if (dgs .le. zero) go to 20
      link = 1
      if (dgs + alpha * gs0 .gt. zero) go to 52
      do 51 i = 1, n
      w(iu + i) = g(i) - w(i)
  51  continue
      sig = one / (alpha * dgs)
      go to 70
  52  continue
      zz = alpha / (dgs - alpha * gs0)
      z = dgs * zz - one
      do 53 i = 1, n
      w(iu+i) = z * w(i) + g(i)
  53  continue
      sig = one / (zz * dgs * dgs)
      go to 70
  60  continue
      link = 2
      do 61 i = 1, n
      w(iu+i) = w(i)
  61  continue
      if (dgs + alpha * gs0 .gt. zero) go to 62
      sig = one / gs0
      go to 70
  62  continue
      sig = -zz
  70  continue
      w(iv+1) = w(iu+1)
      do 71 i = 2, n
      ij = i
      i1 = i - 1
      z = w(iu+i)
      do 72 j = 1, i1
      z = z - h(ij) * w(iv+j)
      ij = ij + n - j
  72  continue
      w(iv+i) = z
  71  continue
      ij = 1
      do 75 i = 1, n
      z = h(ij) + sig * w(iv+i) * w(iv+i)
      if (z .le. zero) z = dmin
      if (z .lt. dmin) dmin = z
      h(ij) = z
      w(ib+i) = w(iv+i) * sig / z
      sig = sig - w(ib+i) * w(ib+i) * z
      ij = ij + np - i
  75  continue
      ij = 1
      do 80 i = 1, n1
      ij = ij + 1
      i1 = i + 1
      do 80 j = i1, n
      w(iu+j) = w(iu+j) - h(ij) * w(iv+i)
      h(ij) = h(ij) + w(ib+i) * w(iu+j)
      ij = ij + 1
  80  continue
      go to (60, 20), link
  90  continue
      iexit = 3
      go to 94
  92  continue
      if (idiff .eq. 2) go to 94
      idiff = 2
      go to 17
  94  continue
      if (iprint .eq. 0) return
      write (6,1005) itn, ifn, iexit,dsqrt(dabs(f)),f
1005  format(' it = ',i4,' if = ',i4,' iexit = ',i3,' sf = ',f10.5,
     &       '  f = ',f10.5) 
c      write (6,1002) f,dsqrt(f)
      write (6,1003) (x(i), i = 1, n)
1003  format(6f14.7)
c      write (6,1004) (g(i), i = 1, n)
      return
 100  continue
      do 101 i = 1, n
      z = hh * xm(i)
      w(i) = w(i) + z
      call funct (w, f1)
      g(i) = (f1 - f) / z
      w(i) = w(i) - z
 101  continue
      ifn = ifn + n
      go to (18, 54), link
 110  continue
      do 111 i = 1, n
      z = hh * xm(i)
      w(i) = w(i) + z
      call funct (w, f1)
      w(i) = w(i) - z - z
      call funct (w, f2)
      g(i) = (f1 - f2) / (two * z)
      w(i) = w(i) + z
 111  continue
      ifn = ifn + n + n
      go to (18, 54), link
      end
c
