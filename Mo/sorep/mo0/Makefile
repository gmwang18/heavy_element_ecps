
# use the compiler call appropriate for your platform
CC = gcc
# note that ANSI-C is required to compile donlp2.c you may have
# to add appropriate options in CFLAGS for your native cc or you may use
# gcc


# you may add or alter compiler options  below -O3 means full optimization
#due to stacksize limitations for large n and n+nlin+nonlin  you might be forced
# to change o8para.h
CFLAGS =  -ansi -pedantic -O3 -no-pie

BASIS = *.h

# for using the old fashioned function form take 
# DRIVER = userfu.o user_eval.o user_init.o  with the codes from
# EXAMPLES_OLD

DRIVER = userfu.o user_eval.o  newx.o

OPTIMIZER = donlp2.o 

.c.o:
	$(CC) $(CFLAGS) -c $<

exe :	$(DRIVER)   $(OPTIMIZER)  
	$(CC) $(CFLAGS) $(DRIVER)  $(OPTIMIZER)  -o exe -lc -lm 

clean :  rm -f *.o

clean_total : clean
	rm -f exe  *.pro *.mes core 

donlp2.o : donlp2.c $(BASIS)
userfu.o : userfu.c  $(BASIS)
user_eval.o : user_eval.c $(BASIS)
newx.o	: newx.c $(BASIS)

