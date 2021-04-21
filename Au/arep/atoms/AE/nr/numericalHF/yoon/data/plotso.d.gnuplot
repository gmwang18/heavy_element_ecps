
# The next section defines the labels for the graph

set term aqua

set title "Li Ground State"
set xlabel "r (Bohr)"
set key top right
unset xrange; unset yrange
unset logscale

# full view
#set xrange[0:21]
#set yrange[-1.4:9]
# 2s tail
#set xrange[22:28]
#set yrange[-0.00:0.00001]
#1s tail
set xrange[7.0:8.5]
set yrange[0.0:0.0000002]

# PNG publishing
#set terminal png font "/sw/lib/X11/fonts/applettf/arial.ttf" 7 size 500,300
#set output

# PS publishing
#set terminal postscript
#set output


# PDF publishing
#set terminal pdf
#set output "2stailsmall.pdf"
#set size 5/5., 3/3.

plot "so.d" using 1:2 with lines
