# This file is called 
#                     Ne6.gnuplot
# Gnuplot script file for plotting data in files

set term aqua
# The next section defines the labels for the graph
#set title "Wave Functions of"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange; unset yrange
unset logscale

#Wave Functions plotted together in a full view
#set yrange[-20.0:62]
set xrange[4.5:5.50]

plot \
"Ne6.gs.2s.4_8.spline" with lines,\
"Ne6.gs.2s.4_7.spline" with lines
