# Gnuplot script file for plotting data in files 
#	B1.gs.2s.y_y.spline
# This file is called B1.gnuplot

# The next section defines the labels for the graph
set title "1s Orbitals for B^{1+}"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[0.0:0.000002]
set xrange[11.50:15.0]

plot "B1.gs.2s.13_2.spline" with lines,\
"B1.gs.2s.13_1.spline" with lines,\
"B1.gs.2s.13_0.spline" with lines,\
"B1.gs.2s.12_9.spline" with lines,\
"B1.gs.2s.12_8.spline" with lines,\
"B1.gs.2s.12_7.spline" with lines,\
"B1.gs.2s.12_6.spline" with lines,\
"B1.gs.2s.12_5.spline" with lines,\
"B1.gs.2s.12_4.spline" with lines,\
"B1.gs.2s.12_3.spline" with lines

set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscr$

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
set terminal pdf
set output "B1_2s_orbtails.pdf"
set size 5/5., 3/3.

plot "B1.gs.2s.13_2.spline" with lines,\
"B1.gs.2s.13_1.spline" with lines,\
"B1.gs.2s.13_0.spline" with lines,\
"B1.gs.2s.12_9.spline" with lines,\
"B1.gs.2s.12_8.spline" with lines,\
"B1.gs.2s.12_7.spline" with lines,\
"B1.gs.2s.12_6.spline" with lines,\
"B1.gs.2s.12_5.spline" with lines,\
"B1.gs.2s.12_4.spline" with lines,\
"B1.gs.2s.12_3.spline" with lines
