# Gnuplot script file for plotting data in files
#	B2.p.2p.xx_x.spline
# This file is called B2.gnuplot

# The next section defines the labels for the graph
set title "Orbitals for B^{1+}"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
set yrange[0.0:0.000001]
set xrange[11.5:13.2]

plot "B2.p.2p.12_2.spline" using ($1):($1*$2) with lines title "12.2",\
"B2.p.2p.12_1.spline" using ($1):($1*$2) with lines title "12.1",\
"B2.p.2p.12_0.spline" using ($1):($1*$2) with lines title "12.0",\
"B2.p.2p.11_9.spline" using ($1):($1*$2) with lines title "11.9",\
"B2.p.2p.11_8.spline" using ($1):($1*$2) with lines title "11.8",\
"B2.p.2p.11_6.spline" using ($1):($1*$2) with lines title "11.6"

set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscr$

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
#set terminal pdf
#set output "B2_2p_orbtails.pdf"
#set size 5/5., 3/3.
