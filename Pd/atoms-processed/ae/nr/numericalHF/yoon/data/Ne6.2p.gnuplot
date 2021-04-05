# This file is called 
#                     Ne6.2p.gnuplot
# Gnuplot script file for plotting data in files

set term aqua
# The next section defines the labels for the graph
# set title ""
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange; unset yrange
unset logscale

#Wave Functions plotted together in a full view
#set yrange[-20.0:62]
set xrange[4.5:5.50]

plot \
"Ne6.p.2p.5_1.spline" with lines,\
"Ne6.p.2p.5_0.spline" with lines,\
"Ne6.p.2p.4_9.spline" with lines,\
"Ne6.p.2p.4_8.spline" with lines,\
"Ne6.p.2p.4_7.spline" with lines
