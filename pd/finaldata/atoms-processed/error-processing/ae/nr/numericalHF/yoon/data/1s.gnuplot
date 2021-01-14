# Gnuplot script file for plotting data in files
# This file is called LithiumWF.gnuplot

# The next section defines the labels for the graph
set title "1s Orbitals of Various Ions"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[-0.1:15.0]
set xrange[0.0:4.0]

plot\
"Limin1s.data" with lines,\
"Be1s.data" with lines,\
"Ne1s.data" with lines
