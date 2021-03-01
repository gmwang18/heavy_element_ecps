# Gnuplot script file for plotting data in files 
#	Be.gs.2s.y_y.spline
# This file is called Be.2s.gnuplot

set term aqua
# The next section defines the labels for the graph
set title "2s Orbitals for Be"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[0.0:0.000002]
set xrange[19.0:22.50]

plot "Be.gs.2s.20_7.spline" with lines,\
"Be.gs.2s.20_6.spline" with lines,\
"Be.gs.2s.20_5.spline" with lines,\
"Be.gs.2s.20_4.spline" with lines,\
"Be.gs.2s.20_3.spline" with lines,\
"Be.gs.2s.20_2.spline" with lines
set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscr$

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
#set terminal pdf
#set output "Be_2s_orbtails.pdf"
#set size 5/5., 3/3.
