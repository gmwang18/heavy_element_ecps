# Gnuplot script file for plotting data in files
# This file is called LithiumWF.gnuplot

# The next section defines the labels for the graph
set title "2s Orbitals of Various Ions"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[-3.0:2.5]
set xrange[0.0:8.0]

plot\
"Limin2s.data" with lines,\
"Be2s.data" with lines,\
"Ne2s.data" with lines
