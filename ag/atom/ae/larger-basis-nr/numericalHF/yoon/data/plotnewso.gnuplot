# Gnuplot script file for plotting data in files
# This file is called

# The next section defines the labels for the graph
set title "Wave Function in new.so.d"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange; unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[-10.0:65.0]
set xrange[0.0:5.0]

plot "new.so.d" with lines
