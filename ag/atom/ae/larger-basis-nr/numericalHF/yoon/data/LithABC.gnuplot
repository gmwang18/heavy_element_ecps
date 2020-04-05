# Gnuplot script file for plotting data in files
# This file is called LithiumWF.gnuplot

# The next section defines the labels for the graph
set title "Wave Functions of Li and Li-"
set xlabel "r (Bohr)"
set ylabel "Psi(r)"
set key top right
unset xrange; unset yrange
unset logscale

# Define any special labels
#set label 1
#set label 2

# The functions for the Roos ANO
#f1(x) = 0.181576*exp(-9497.93*x*x)+0.340498*exp(-1416.81*x*x)+0.587115*exp(-321.46*x*x)+0.938963*exp(-91.1242*x*x)+1.37145*exp(-29.9999*x*x)+1.75333*exp(-11.0176*x*x)+1.82872*exp(-4.3728*x*x)+1.42221*exp(-1.83126*x*x)+0.64973*exp(-0.802261*x*x)+0.101986*exp(-0.362648*x*x)+0.00131046*exp(-0.113995*x*x)+0.000331126*exp(-0.051237*x*x)+8.23995e-05*exp(-0.022468*x*x)
#f2(x) = -0.026738*exp(-9497.93*x*x)+-0.0500011*exp(-1416.81*x*x)+-0.0864466*exp(-321.46*x*x)+-0.13882*exp(-91.1242*x*x)+-0.205893*exp(-29.9999*x*x)+-0.271458*exp(-11.0176*x*x)+-0.304042*exp(-4.3728*x*x)+-0.278913*exp(-1.83126*x*x)+-0.220478*exp(-0.802261*x*x)+-0.110638*exp(-0.362648*x*x)+0.109108*exp(-0.113995*x*x)+0.161448*exp(-0.051237*x*x)+0.0431831*exp(-0.022468*x*x)

#Wave Functions plotted together in a full view
set yrange[0.0:0.250]
set xrange[0.0:15.0]

plot "LipWF" title 'Li Composite' with lines,\
"Limin.ground.wf" title 'Li- ground state' with lines, \
"Li.diffuse.wf" title 'Li with fractional e- in p orbital' with lines
