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
set xrange[50:75.0]

plot \
"fort.26" with lines,\
"Limin.aug.2s.67_0.spline" with lines,\
"Limin.aug.2s.66_0.spline" with lines,\
"Limin.aug.2s.65_0.spline" with lines,\
"Limin.aug.2s.64_0.spline" with lines,\
"Limin.gs.2s.72_2.spline" with lines,\
"Limin.gs.2s.72_0.spline" with lines
