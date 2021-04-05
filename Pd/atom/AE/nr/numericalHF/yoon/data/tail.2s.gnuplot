# Gnuplot script file for plotting data in files 
#	2s splines
# This file is called tail.2s.gnuplot

# The next section defines the labels for the graph
set title "Normalized 2s Orbitals for 4e Iso-electronic Series"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

#Wave Functions plotted together in a full view
#set yrange[0.0:0.000002]
set xrange[1.5:20]

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output

# PDF publishing
set terminal pdf
set output "tail.2s.pdf"
set size 5/5., 3/3.

plot "Limin.gs.2s.spline" with lines lw 3 title "Li^{-}",\
"Be.gs.2s.20_3.spline" with lines lw 3 title "Be",\
"B1.gs.2s.12_7.spline" with lines lw 3 title "B^{1+}",\
"Ne2s.data" with lines lw 3 title "Ne^{6+}",\
"Mg8.gs.2s.spline" with lines lw 3 title "Mg^{8+}",\
"Ca16.gs.2s.spline" with lines lw 3 title "Ca^{16+}",\
"Ni24.gs.2s.spline" with lines lw 3 title "Ni^{24+}
