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
set xrange[6.5:7.50]

plot \
"Limin.gs.1s.7_0.spline" with lines,\
"Limin.gs.1s.6_9.spline" with lines,\
"Limin.gs.1s.6_8.spline" with lines,\
"Limin.gs.1s.6_7.spline" with lines,\
"Limin.gs.1s.6_6.spline" with lines,\
"Limin.gs.1s.6_5.spline" with lines,\
"Limin.gs.1s.6_4.spline" with lines

