# Gnuplot script file for plotting data in files 
#	Li.half.2p.spline
#	Li.p.2p.spline
#	Li.1_8s.2p.spline
# This file is called Liwf.gnuplot

# View
#set yrange[0.0:0.000002]
set xrange[0.00:50.0]

# The next section defines the labels for the graph
set title "p-symmetry Orbitals for Li^{1-}"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscr$

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
#set terminal pdf
#set output "Liminptails.pdf"
#set size 5/5., 3/3.

plot "Li.halfp.2p.spline" using ($1):($1*$2) with lines,\
"Li.p.2p.spline" using ($1):($1*$2) with lines,\
"Li.1_8s.2p.spline" using ($1):($1*$2) with lines
