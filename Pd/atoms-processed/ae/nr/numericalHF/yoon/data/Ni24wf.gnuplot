# Gnuplot script file for plotting data in files 
#	Ni24.gs.1s.spline
#	Ni24.gs.2s.spline
#	Ni24.p.2p.spline
# This file is called Ni24wf.gnuplot

# The next section defines the labels for the graph
set title "Wave Function for Ni24"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
#set yrange[0.0:50.0]
#set xrange[0.0:.5]

plot "Ni24.gs.1s.spline" with lines,\
"Ni24.gs.2s.spline" with lines,\
"Ni24.p.2p.spline" using ($1):($1*$2) with lines

set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscr$

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
#set terminal pdf
#set output "Ni24orbs.pdf"
#set size 5/5., 3/3.

#plot "Ni24.1s.spline" with lines,\
#"Ni24.2s.spline" with lines,\
#"Ni24.2p.spline" with lines
