# Gnuplot script file for plotting data in files 
#	1s splines
# This file is called all.1s.gnuplot

# The next section defines the labels for the graph
set title "Normalized 1s Orbitals for 4e Iso-electronic Series"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
#set yrange[0.0:0.000002]
set xrange[0.0:1.50]

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output

# PDF publishing
set terminal pdf
set output "all.1s.pdf"
set size 5/5., 3/3.

plot "Limin.gs.1s.spline" with lines lw 3 title "Li^{-}",\
"Be.gs.1s.4_9.spline" with lines lw 3 title "Be",\
"B1.gs.1s.3_5.spline" with lines lw 3 title "B^{1+}",\
"Ne1s.data" with lines lw 3 title "Ne^{6+}",\
"Mg8.gs.1s.spline" with lines lw 3 title "Mg^{8+}",\
"Ca16.gs.1s.spline" with lines lw 3 title "Ca^{16+}",\
"Ni24.gs.1s.spline" with lines lw 3 title "Ni^{24+}"
