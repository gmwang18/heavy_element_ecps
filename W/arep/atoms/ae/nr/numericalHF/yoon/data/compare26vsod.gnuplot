# Gnuplot script file for plotting data

# The next section defines the labels for the graph
set title "Orbitals of Mg8+"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange
unset yrange
unset logscale

# Define any special labels
set label "both 1s" at -0.1,22
set arrow from 0.07,22 to 0.11,22
set label "both 2s" at -0.12,-8
set arrow from 0.05,-8 to 0.08,-8
set label "proper 2p" at -0.12,4
set arrow from 0.05,4 to 0.09,4
set label "2p result from wwhf3.f" at 0.3,22
set arrow from 0.28,22 to 0.25,22

#Wave Functions plotted together in a full view
set yrange[-25.0:81.0]
set xrange[0.0:1.5]

set fontpath "/usr/X11R6/lib/X11/fonts/Type1" "/usr/lib/X11/fonts!" "/usr/local/share/ghostscript/fonts"

# Aquaterm publishing
#plot "fort.26" with lines,\
#"so.d" using 1:2 with lines

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output "splineinvestigation.png"
#plot "fort.26" with lines,\
#"so.d" using 1:2 with lines

# PS publishing
#set terminal postscript
#set output "splineinvestigation.tex"
#plot "fort.26" with lines,\
#"so.d" using 1:2 with lines


# PDF publishing
set terminal pdf
set output "splineinvestigation.pdf"
set size 5/5., 3/3.
plot "fort.26" with lines,\
"so.d" using 1:2 with lines
