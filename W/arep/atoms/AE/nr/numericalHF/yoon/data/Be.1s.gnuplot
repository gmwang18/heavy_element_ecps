# Gnuplot script file for plotting data in files 
#	Be.gs.1s.y_y.spline
# This file is called Be.1s.gnuplot

set term aqua
# The next section defines the labels for the graph
set title "1s Orbitals for Be"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[0.0:0.0000002]
set xrange[5.4:6.10]

plot "Be.gs.1s.5_0.spline" with lines,\
"Be.gs.1s.4_9.spline" with lines,\
"Be.gs.1s.4_8.spline" with lines

set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscr$

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
#set terminal pdf
#set output "Be_1s_orbtails.pdf"
#set size 5/5., 3/3.
