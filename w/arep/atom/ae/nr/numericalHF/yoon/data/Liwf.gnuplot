# Gnuplot script file for plotting data in files 
#	Limin.gs.1s.spline
#	Limin.gs.2s.spline
#	Li.p.2p.spline
# This file is called Liwf.gnuplot

set term aqua
# The next section defines the labels for the graph
set title "Orbitals for Li^{1-}"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[0.0:0.000001]
set xrange[30.0:80.00]

plot "Limin.gs.1s.spline" with lines,\
"Limin.gs.2s.spline" with lines,\
"Li.p.2p.spline" using ($1):($1*$2) with lines

set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscr$

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
#set terminal pdf
#set output 
#set size 5/5., 3/3.
