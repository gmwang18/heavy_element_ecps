          character*1 dum
          read (10,*) nchan
          read (10,100) dum
100    format(a1)
      do i=1,nchan
      read (10,*) ng
      write (11,*) ng
         do j=1,ng
         read (10,*) c,n,e
         write (11,101) n,e,c
101    format(i1,1x,2f16.8)
         enddo
      enddo
      end
