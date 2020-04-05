# This file is called 
#                     Ne6.gnuplot
# Gnuplot script file for plotting data in files

set term aqua
# The next section defines the labels for the graph
#set title "Wave Functions of "
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange; unset yrange
unset logscale

#Wave Functions plotted together in a full view
#set yrange[-20.0:62]
set xrange[1.75:2.250]

plot \
"Ne6.gs.1s.2_0.spline" with lines,\
"Ne6.gs.1s.1_9.spline" with lines,\
"Ne6.gs.1s.1_8.spline" with lines,\
"Ne6.gs.1s.1_7.spline" with lines,\
"Ne6.gs.1s.1_6.spline" with lines

