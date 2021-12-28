#!/bin/bash

HOME=`pwd`
echo ecp:
cat params.in

#This is alpha
exp1=`grep 'x1' workdir/params.in | awk '{print $1}'`
exp2=`grep 'x2' workdir/params.in | awk '{print $1}'`
exp3=`grep 'x3' workdir/params.in | awk '{print $1}'`
exp4=`grep 'x4' workdir/params.in | awk '{print $1}'`
exp5=`grep 'x5' workdir/params.in | awk '{print $1}'`
exp6=`grep 'x6' workdir/params.in | awk '{print $1}'`
exp7=`grep 'x7' workdir/params.in | awk '{print $1}'`
exp8=`grep 'x8' workdir/params.in | awk '{print $1}'`
exp9=`grep 'x9' workdir/params.in | awk '{print $1}'`


exp0=`grep 'y1' workdir/params.in | awk '{print $1}'`


coeff1=`grep 'y2' workdir/params.in | awk '{print $1}'`
coeff2=`grep 'y3' workdir/params.in | awk '{print $1}'`
coeff3=`grep 'y4' workdir/params.in | awk '{print $1}'`
coeff4=`grep 'y5' workdir/params.in | awk '{print $1}'`
coeff5=`grep 'y6' workdir/params.in | awk '{print $1}'`
coeff6=`grep 'y7' workdir/params.in | awk '{print $1}'`
coeff7=`grep 'y8' workdir/params.in | awk '{print $1}'`
coeff8=`grep 'y9' workdir/params.in | awk '{print $1}'`
zeff=7.0
zeffexp7=`echo $zeff*$exp7 | bc -l`


sed "s/EXP1/$exp1/g; \
     s/EXP2/$exp2/g; \
     s/EXP3/$exp3/g; \
     s/EXP4/$exp4/g; \
     s/EXP5/$exp5/g; \
     s/EXP6/$exp6/g; \
     s/EXP7/$exp7/g; \
     s/EXP8/$exp8/g; \
     s/EXP9/$exp9/g; \
     s/EXP0/$exp0/g; \
     s/COEFF1/$coeff1/g; \
     s/COEFF2/$coeff2/g; \
     s/COEFF3/$coeff3/g; \
     s/COEFF4/$coeff4/g; \
     s/COEFF5/$coeff5/g; \
     s/COEFF6/$coeff6/g; \
     s/COEFF7/$coeff7/g; \
     s/COEFF8/$coeff8/g; \
     s/Zeff/$zeff/g; \
     s/zeffexp7/$zeffexp7/g; " molpro.d > $HOME/mol.d

cat mol.d

