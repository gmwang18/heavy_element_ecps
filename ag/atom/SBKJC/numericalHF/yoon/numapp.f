c
c************************************************************************c
c******************************* NUMAPP *********************************c
c************************************************************************c
c
      subroutine numapp(strng,num)
c************************************************************************c
c   This subroutine appends the number num to the end of the string      c
c   strng.                                                               c
c************************************************************************c
      character*(*) strng
      integer num,strlen
      character*10 int2ch,numstr
c
c
c
      strlen = len(strng)
      call ljust(strng,strlen)
      numstr = int2ch(num)
      strng(strlen+1:) = numstr
      return
      end
c
c************************************************************************c
c******************************* INT2CH *********************************c
c************************************************************************c
c
      character*10 function int2ch(num)
c************************************************************************c
c   converts an integer to its character equivalent.                     c
c************************************************************************c
      integer num,pos,tnum
      integer remain,zeropos
      character*10 tem
c
c
c
      tnum = num
      int2ch = '          '
      tem = '          '
      pos = 10
      zeropos = ichar('0')
 1    continue
      remain = mod(tnum,10)
      tem(pos:pos) = char(remain+zeropos)
      tnum = tnum/10
      pos = pos - 1
      if ((tnum .ne. 0) .and. (pos .gt. 0)) goto 1
      int2ch(1:10-pos) = tem(pos+1:10)
      return
      end
c
c************************************************************************c
c******************************** LJUST *********************************c
c************************************************************************c
c
      subroutine ljust(strng,truelen)
c************************************************************************c
c   This subroutine eliminates any leading blanks in a string, and any   c
c   blanks that are in the string itself  (e.g. ' f  g hj' is returned   c
c   as 'fghj').  truelen is the number of nonblank characters in strng.  c
c************************************************************************c
      character strng*(*),tmp*200,space*200
      integer length,pos,i,truelen
c
      do 3 i=1,200
         space(i:i) = ' '
 3    continue 
c
c
c
      length = len(strng)
      i = 1
      do 110 pos=1,length
         if (strng(pos:pos) .ne. ' ') then
            tmp(i:i) = strng(pos:pos)
            strng(pos:pos) = ' '
            i = i+1
         end if
 110  continue 
      i = i-1
      strng = tmp(1:i)//space(i+1:length)
      truelen = i
      return
      end

