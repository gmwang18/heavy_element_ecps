#-------------PUBLISHING----------------------------------

# *********** PS publishing ******************************
set terminal postscript enhanced color eps "Helvetica" 26
set output "Li.gs.full.eps"
#set output "Li.gs.2stail.eps"
#set size 5/5, 3.5/3.5
#set size 1,1.5
set size 1.0,1.0
# *********** PDF publishing *****************************
#set terminal pdf
#set output 
#set size 5/5., 3/3.
# *********** Auqaterm publishing ************************
#set term aqua

#-------------DATA FITTING--------------------------------
#f1(x) = a1*x +b1        # define the function to be fit
#a1 = 0.1; b1 = 0.01    # initial guess
#fit f1(x) 'HFwf.dat' using ($1):($4-$3):($5) via a1,b1

#-------------LABELS--------------------------------------
#set key top left
set nokey

# these are Jindra's settings that I don't understand yet
#forces decimal output and ?
#set format x "%.1f"
set format y "%.2f"
set samples 1000
set clip two 
set noclip one

set title "Li Ground State"
#unset title
set xlabel "r (Bohr)"
set ylabel "Psi(r) (normalized units)"

#-------------VIEW---------------------------------------
unset xrange
unset yrange
unset logscale
# full view
set xrange[0:21]
set yrange[-1.4:9]
# 2s tail
#set xrange[22:28]
#set yrange[-0.00:0.00001]
#1s tail
#set xrange[7.0:8.5]
#set yrange[0.0:0.0000002]

#-------------PLOT THE DAMN THING!-----------------------
plot "Li.gs.1s.spline" using 1:2 with lines,\
"Li.gs.2s.spline" using 1:2 with lines