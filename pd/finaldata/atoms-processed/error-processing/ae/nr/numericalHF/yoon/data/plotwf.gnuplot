# Gnuplot script file for plotting data in files
#
# This file is called

set term aqua
# The next section defines the labels for the graph
set title "Wave Function in fort.26"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#View is zoomed to the tail
set yrange[0.0:0.25]
set xrange[0.0:20.00]

plot "fort.26" with lines
