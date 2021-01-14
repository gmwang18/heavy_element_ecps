# Gnuplot script file for plotting data in files
# This file is called LithiumWF.gnuplot

# The next section defines the labels for the graph
set title "Wave Function for Ca16"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[0.0:0.000001]
#set xrange[0.0:3]



set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscr$

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
#set terminal pdf
#set output "Ca16orbs.pdf"
#set size 5/5., 3/3.
