# Gnuplot script file for plotting data in files 
#	B1.p.2p.y_y.spline
# This file is called B1.2p.gnuplot


set term aqua
# The next section defines the labels for the graph
set title "1s Orbitals for B^{1+}"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[0.0:0.0000005]
set xrange[13:14.50]

plot "B1.p.2p.13_8.spline" using ($1):($1*$2) with lines,\
"B1.p.2p.13_7.spline" using ($1):($1*$2) with lines,\
"B1.p.2p.13_6.spline" using ($1):($1*$2) with lines,\
"B1.p.2p.13_5.spline" using ($1):($1*$2) with lines,\
"B1.p.2p.13_4.spline" using ($1):($1*$2) with lines,\
"B1.p.2p.13_3.spline" using ($1):($1*$2) with lines,\
"B1.p.2p.13_2.spline" using ($1):($1*$2) with lines
#"B1.p.2p.13_1.spline" using ($1):($1*$2) with lines,\
#"B1.p.2p.13_0.spline" using ($1):($1*$2) with lines

set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscr$

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
#set terminal pdf
#set output "B1_p_2p_orbtails.pdf"
#set size 5/5., 3/3.
