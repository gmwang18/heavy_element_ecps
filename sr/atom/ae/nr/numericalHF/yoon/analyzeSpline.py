###########################
# title:    analyzeSpline.py
# author:   Kevin M. Rasch
# version:  Python 2.6
#           numpy-1.0
#           scipy-0.9
#           matplotlib-
# descrtipion:
# This program reads in a list of r, Psi(r) values and plots out
# Psi(r), Psi'(r), Psi''(r), and Psi'''(r) for visual inspection for smoothness
###########################
# USER ARGUMENTS
# 1. [name.spline]  -- the first argument to the Python script should be the
#                      name of the spline file.
# 2. figure [string] -- the name of the file you want to save the figure to
###########################
# THE IMPORTS:
from sys import argv
from scipy.interpolate import UnivariateSpline
import pylab as pyl
###########################
# THE CODE
# 1.  check that the spline name was given
if len(argv) == 1:
    print "The name of a spline file must be given."
print "Looking for spline in ",argv[1]
figure_filename="temp.pdf"
# 2.  process options
for i in range(len(argv)):
    if argv[i]=='figure':
        figure_filename=str(argv[i+1])
        print "Saving output to ",figure_filename
spline = open(argv[1],'r')
if spline == False:
    print "Could not find ",argv[1]
x=[] #for holding radial distance from the atom
y=[] #for holding wave function values Psi(r)
for line in spline:
    x.append( float(line.split()[0]))
    y.append( float(line.split()[1]))
#    print x, y

# graphs:  output data
v = UnivariateSpline(x, y, k=3, s=0.0) # 3th degree spline
w = UnivariateSpline(x, y, k=5, s=0.0) # 5rd degree spline
vpsi     = v(x)
vpsi_d   = v(x,1)
vpsi_dd  = v(x,2)
vpsi_ddd = v(x,3)
wpsi     = w(x)
wpsi_d   = w(x,1)
wpsi_dd  = w(x,2)
wpsi_ddd = w(x,3)
pyl.figure(1)
pyl.subplot(511)
pyl.title('Splining of Output, Degree: 3rd(red)  5th(blue)')
pyl.xlabel('r')
pyl.ylabel('Psi(r)')
pyl.semilogy(x, y,'xg')
pyl.semilogy(x, vpsi,'-r')
pyl.semilogy(x, wpsi, '-b')
pyl.subplot(512)
pyl.xlabel('r')
pyl.ylabel('Psi(r)')    
pyl.plot(x, y,'xg')
pyl.plot(x, vpsi,'-r')
pyl.plot(x, wpsi,'-b')
pyl.subplot(513)
pyl.xlabel('r')
pyl.ylabel('d_r Psi(r)')
pyl.semilogy(x, abs(vpsi_d), '-r')
pyl.semilogy(x, abs(wpsi_d), '-b')
pyl.subplot(514)
pyl.xlabel('r')
pyl.ylabel('dd_r Psi(r)')
pyl.semilogy(x, abs(vpsi_dd), '-r')
pyl.semilogy(x, abs(wpsi_dd), '-b')
pyl.subplot(515)
pyl.xlabel('r')
pyl.ylabel('ddd_r Psi(r)')
pyl.semilogy(x, abs(vpsi_ddd), '-r')
pyl.semilogy(x, abs(wpsi_ddd), '-b')
pyl.savefig(figure_filename)
pyl.show()
# end of graphing
