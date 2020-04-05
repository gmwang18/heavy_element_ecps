###########################
# title:    prepareSplines.py
# author:   Kevin M. Rasch
# version:  Python 2.6
#           numpy-1.0
#           scipy-0.9
#           matplotlib - comment out the graphs at the end and use your own 
#                        graphing tool if you dont have this installed
# descrtipion:
# This program collects r, phi(r) data from a given spline produce by the nhf
# code used in the Mitas QMC Group, and it produces a spline with the tail
# extended according to a fit to hydrogenic form.
###########################
# REQUIRED USER ARGUMENTS
# the following arguments are required
# 
# 1. [spline name string]
#
# 2. -l [int]       -- an integer representing the value of the angular
#                      momentum quantum number
# 3. -n [int]       -- an integer representing the value of the principle
#                      quantum number
###########################
# OPTIONAL USER ARGUMENTS
# the following arguments may be passed to python after the sciptname:
#
# 
# 1. -height [float] -- over-rides the scripts value of psi(r) to use to define
#                       the last entry of the orbital
#
# 2. -step [float]   -- over-ride the original step size in the output
###########################
# THE IMPORTS:
from sys import argv
import os
#import numpy as np
#from scipy.optimize import curve_fit
#from scipy.interpolate import UnivariateSpline
#import pylab as pyl
###########################
# THE CODE:
# 1.a. check options given to this script
print "Analyzing the spline in",argv[1]
raw_spline_name = argv[1]
height = 0.00000001
step = 0.0
azimuthal = 10
principle = 0
for i in range(len(argv)):
    if argv[i] == '-l':
        azimuthal = int( argv[i+1])
    if argv[i] == '-n':
        principle = int( argv[i+1])
    if argv[i] == '-step':
        step = float( argv[i+1])
    if argv[i] == '-height':
        height = float( argv[i+1])

# 1.b. produce error messages
if principle == 0:
    print "No principle quantum number given!"
    raise SystemExit
if azimuthal == 10:
    print "No azimuthal quantum number given!"
    raise SystemExit
if azimuthal >= principle:
    print "You've made a mistake; you are telling me that l > n."
    raise SystemExit

# 2. pick up and parse a numerical hartree-fock spline
splineIN = open(raw_spline_name,'r')
read_x = []
read_y = []
line = splineIN.readline()
while line:
        words = line.split()
        if len(words) > 1:
            read_x.append( float( words[0]))
            read_y.append( float( words[1]))
        line = splineIN.readline()

# compute the step size if it has not already been given
if step == 0.0:
    step = read_x[1] - read_x[0]

# determine the generalized Laguerre polynomial appropriate to the orbital
hi = 2*azimuthal + 1 # hi index of generalized Laguerre poly
lo = principle - azimuthal -1 # low index of generalized Laguerre poly

# check for validity
if lo >= 4:
    print "Laguerre polynomials implemented up to n=4"
    raise SystemExit

# 

# form of the tail that data will be fit to
def tail(x, a, b , azimuthal):
    return a*pow(x,azimuthal)*np.exp(-b*x)
