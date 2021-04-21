# Gnuplot script file for plotting data in files Mg8.gs.spline & Mg8.p.spline
# This file is called Mg8.gnuplot

# The next section defines the labels for the graph
set title "Wave Function Orbitals for Mg8+"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

# Put the Wave Functions in view
set yrange[-25.0:81.0]
#set xrange[0.0:5]

plot "Mg8.1s.spline" with lines,\
"Mg8.2s.spline" with lines,\
"Mg8.2p.spline" with lines

set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscr$

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
#set terminal pdf
#set output "Mg8orbs.pdf"
#set size 5/5., 3/3.

#plot "Mg8.1s.spline" with lines,\
#"Mg8.2s.spline" with lines,\
#"Mg8.2p.spline" with lines
