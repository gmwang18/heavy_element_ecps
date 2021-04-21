# Gnuplot script file for plotting data in files 
#	Limin.gs.1s.spline
#	Limin.gs.2s.spline
#	Limin.p.2p.spline
# This file is called

# The next section defines the labels for the graph
set title "Orbitals for Li^{1-}"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[0.0:1.50]
set xrange[0.0:40]

plot "Limin.gs.1s.6_5.spline" with lines,\
"Limin.gs.2s.72_2.spline" with lines,\
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
#set output "Ni24orbs.pdf"
#set size 5/5., 3/3.
