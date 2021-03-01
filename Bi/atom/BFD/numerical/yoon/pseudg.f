	subroutine pseudg (r,vs,vp,vd,vf,vloc,vloc1)
c
c	routine for pseudopotenatial evaluation 
c	pp - Christiansen et al., Stevens et al., Pacios et al.,
c            Dolg et al.
c
c	r  -  radius
c       vs, vp, - s and p pseudopotentials 
c       vd is added by Guangming to add additional channel. 
c       vf is further added by Guangming to for ECP optimization project
c             for heavy element transition metal.
c	vloc    - d and higher l pseudopotential 
c
	implicit double precision (a-h,o-z)
	parameter (imax=50,lmax=5)
	dimension m(lmax),ns(imax,lmax),es(imax,lmax),c(imax,lmax)
	data init/0/
	save
c
	if (init.eq.0)					then
        open(99,file='pp.d.GAM',status='unknown',form='formatted')
        open(98,file='pp.d.CRY',status='unknown',form='formatted')
	open(1,file='pp.d',status='old',form='formatted')
		read (1,*) zion,ll
		read (1,*) (m(l),l=1,ll)
		do 20 l=1,ll
		write (99,*) ' '
		write (98,*) ' '
		do 10 i=1,m(l)
		read (1,*) ns(i,l),es(i,l),c(i,l)
		write (99,*) c(i,l),ns(i,l),es(i,l)
		write (98,*) es(i,l),c(i,l),ns(i,l)-2
 10		continue
 20		continue
		lact=ll
		init=1
		vs=0.
		vp=0.
		vd=0.
		vf=0.
	close(1)
							endif
		r2=r*r
		do 50 l=1,ll
		sum=0.
		do 40 i=1,m(l)
		esr2=es(i,l)*r2
		ee=0.
		if (esr2.lt.70.d+00)	ee=dexp(-esr2)
		sum=sum+c(i,l)*(r**ns(i,l))*ee/r2
 40		continue	
		if (l.eq.1)	vs=sum
		if (lact.eq.2)	then
		if (l.eq.2)	vloc1=sum
		if (l.eq.2)	vloc=sum-zion/r
				else
		if (l.eq.2)     vp=sum
		if (lact.eq.3)	then
		if (l.eq.3)     vloc1=sum
		if (l.eq.3)     vloc=sum-zion/r
				else
		if (l.eq.3)     vd=sum
		if (lact.eq.4)	then
		if (l.eq.4)     vloc1=sum
		if (l.eq.4)     vloc=sum-zion/r
				else
		if (l.eq.4)     vf=sum
		if (l.eq.5)     vloc1=sum
		if (l.eq.5)     vloc=sum-zion/r
				endif
				endif
				endif
 50		continue
						return
	end
