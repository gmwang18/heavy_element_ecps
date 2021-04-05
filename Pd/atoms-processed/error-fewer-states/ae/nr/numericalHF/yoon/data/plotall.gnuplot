# Gnuplot script file for plotting data in files
# This file is called

# The next section defines the labels for the graph
set title "Wave Function in fort.26"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

# Define any special labels
#set label 1
#set label 2

#Wave Functions plotted together in a full view
set yrange[-57.0:176.0]
set xrange[0.0:5.0]


plot "fort.26" with lines,\
"so.d" using 1:2 with lines,\
"new.so.d" with lines,\
"fort.44" with lines
