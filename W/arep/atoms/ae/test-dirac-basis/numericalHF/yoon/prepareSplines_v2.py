
###########################
# title:    prepareSplines.py
# author:   Kevin M. Rasch
# version:  Python 2.6
#           numpy-1.0
#           scipy-0.9
#           matplotlib - comment out the graphs at the end and use your own 
#                        graphing tool if you dont have this installed
# descrtipion:
# This program collects r, r^(l+1)*phi(r) data from fort.25 produce by the nhf
# code used in the Mitas QMC Group and produces a set of uniformly splined
# orbitals ready for use as basis functions in qwalk
###########################
# OPTIONAL USER ARGUMENTS
# the following arguments may be passed to python after the sciptname
# 1. unique [int]  -- tells the script how many unique orbitals are in fort.25
#                     otherwise it will use number of states in the nhf calc.
# 2. spline_step [float] -- sets the step size of the output spline
#                           otherwise the longest orbital is divided by 2000
# 3. cusp [int] -- tells the script to fix psi(0) to match the analytic cusp
#            for use in all-electron calculations
# 4. height [float] -- over-rides the scripts value of psi(r) to use to define
#                      the tail default is 0.00025
###########################
# THE IMPORTS:
from sys import argv
import numpy as np
from scipy.optimize import curve_fit
from scipy.interpolate import InterpolatedUnivariateSpline
import pylab as pyl
###########################
# THE CODE:
# check options given to this script
unique_orbs = 0
step_size = 0.0
analytic_nuclear_cusp = False
height = 0.00025
if len(argv) > 1:
    for l in range(len(argv)):
        if argv[l] == 'unique':
            unique_orbs = int(argv[l+1])
        if argv[l] == 'spline_step':
            step_size = float(argv[l+1])
        if argv[l] == 'cusp':
            analytic_nuclear_cusp = True
        if argv[l] == 'height':
            height = float(argv[l+1])

# pick up and parse a numerical hartree-fock calculation
spline = open('fort.25','r')
firstline = spline.readline()
norbs = int(firstline.split()[0])
print "I see",norbs,"orbitals."
if unique_orbs == 0:
    unique_orbs = norbs
cusp = float(-1.0)*float( firstline.split()[1])
print "I see that Z =",-1.0*cusp,"."
print "I see that you want the tail to begin when psi(r) is less than ",height
longest_orbital = 0.0
symmetry = []

data_set = []
# begin storing logarithmic spline info from fort.25 into data_set
#   data_set[j] is a list of 2 lists (r,phi(r)) for orb j
#   data_set[j][0] is a list of r values for orb j
#   data_set[j][1] is a list of phi(r) values for orb j
#   data_set[j][0][i] is the ith r value of the jth orbital

output_set = []
# output_set is indexed the same as data_set and is where the output will go
for j in range(unique_orbs):
    headerline = spline.readline()
    print "Reading in orb",j+1,"."
    nextorblength = int(headerline.split()[0])
    symmetry.append( int(headerline.split()[1]) )
    print "Symmetry of orb ",j," is ",symmetry[j]
    read_x = []
    read_y = []
    for i in range(nextorblength):
        line = spline.readline()
        read_x.append( float(line.split()[1]))
        read_y.append( float(line.split()[2])/ float(line.split()[1])**(1+symmetry[j]) )
    # remove 0.0's up to 1E-7 in phi(r)
    while read_y[-1] < 1E-7:
        throwawayx = read_x.pop()
        throwawayy = read_y.pop()
    print "Orb",j+1,"ends at",read_x[-1],read_y[-1]
    # if requested, enforce the analytic derivative at r==0
    if analytic_nuclear_cusp:
        if read_x[0] != 0.0:
            psi_zero = read_y[0] - cusp*read_x[0]
            read_x.insert(0,0.0)
            read_y.insert(0,psi_zero)
        if read_x[0] == 0.0:
            psi_zero = read_y[1] - cusp*(read_x[1]-read_x[0])
            read_y[0] = psi_zero
    # store x,y lists into single_orb
    single_orb = []
    single_orb.append(read_x)
    single_orb.append(read_y)
    # store single_orb into data_set
    data_set.append(single_orb)
    # remember the length of the longest orbital
    orbital_end = float(data_set[j][0][-1])
    if orbital_end > longest_orbital:
        longest_orbital = orbital_end
print "Longest orbital was ", longest_orbital,"."
# compute the step size based on the longest orbital if not specified by user
if step_size == 0.0:
    step_size = longest_orbital / 2000.0
# loop over stored orbitals and fit, interpolate, and write out
for j in range(unique_orbs):
    print "Preparing orbital ",j+1,"."
    # select point to match proper exponential tail and nhf orbital spline
    orbital_end = float(data_set[j][0][-1])
    k = int(0)
    while data_set[j][1][-1-k] < height:
        cut = data_set[j][0][-1-k]
        k += 1
    print "Matching the tail at r=",cut
    # collect the tail data points in tempoaray storage
    temp_x = []
    temp_y = []
    for i in range(len(data_set[j][0])):
        if data_set[j][0][i] > 0.9*cut:
            temp_x.append(data_set[j][0][i])
            temp_y.append(data_set[j][1][i])
    fit_r = np.array(temp_x, dtype=float)
    fit_phi = np.array(temp_y, dtype=float)
    # form of the tail that data will be fit to
    def tail(x, a, b ):
        return a*pow(x,symmetry[j])*np.exp(-b*x)
    popt, pcov = curve_fit(tail, fit_r, fit_phi)
    # return least-squares fit a,b in popt
    print "Tail is fit by ", popt[0],"*e^{-",popt[1],"x}"
    # return covariance of parameters
    print "covariance"
    print pcov
    # construct a curve using fit parameters
    fit_curve = []
    for i in range(len(data_set[j][0])):
        fit_curve.append( tail( data_set[j][0][i], popt[0], popt[1]))
    # buid splice orbital data from original and exponential-fit tail
    splice_x = []
    splice_y = []
    for i in range(len(data_set[j][0])):
        if data_set[j][0][i] < cut:
            splice_x.append(data_set[j][0][i])
            splice_y.append(data_set[j][1][i])
        if data_set[j][0][i] > cut:
            if fit_curve[i] > 1E-7:
                splice_x.append(data_set[j][0][i])
                splice_y.append(fit_curve[i])
    # extend tail until psi(r) is less than 1E-7
    #distance = data_set[j][0][-1]
    #while abs(splice_y[-1]) > 0.0000001:
    #    additional_step = 0.05
    #    distance += additional_step
    #    splice_x.append(distance)
    #    splice_y.append( tail(distance,popt[0],popt[1]))
    # build a filename for output
    outfilename = "orb"+str(j+1)
    output = open(outfilename,'w')
    # crude interpolation function
    # x is a list of x values of a spline
    # y is a list of f(x) of the same spline
    # xpos is the x value you'd like to know f(x) for
    #def lookup_y(x,y,xpos):
    #    z = 0
    #    while z < len(splice_x):
    #        if x[z] >= xpos:
    #            return ((y[z]-y[z-1])/(x[z]-x[z-1]))*(xpos-x[z-1])+y[z-1]
    #        else:
    #            z += 1
    s = InterpolatedUnivariateSpline(splice_x, splice_y, k=3)
    # fill an array of the desired x points
    k = 0.0
    output_x = []
    while k < splice_x[-1]:
        output_x.append(k)
        k += step_size
    output_y = s(output_x)
    psi_d   = s(output_x,1)
    psi_dd  = s(output_x,2)
    psi_ddd = s(output_x,3)
    for l in range(len(output_x)):
        line = str(output_x[l])
        line = line+"     "+str(output_y)+"\n"
        output.write(line)
    single_orb = []
    single_orb.append(output_x)
    single_orb.append(output_y)
    # store single_orb into data_set
    output_set.append(single_orb)
    # open graphs to show final output
    # comment out below to circumvent graphing
    pyl.close()
    pyl.figure(1)
    pyl.subplot(511)
    pyl.title('compare nhf tail (red) and fit tail (blue)')
    pyl.xlabel('r')
    pyl.ylabel('Psi(r)')
    pyl.semilogy(data_set[j][0], data_set[j][1],'-r')
    pyl.semilogy(output_set[j][0], output_set[j][1],'-b')
    pyl.subplot(512)
    pyl.title('compare nhf tail (red) and fit tail (blue)')
    pyl.xlabel('r')
    pyl.ylabel('Psi(r)')    
    pyl.plot(data_set[j][0],data_set[j][1],'-r')
    pyl.plot(output_set[j][0], output_set[j][1],'xb')
    pyl.subplot(513)
    pyl.xlabel('r')
    pyl.ylabel('d_r Psi(r)')
    pyl.semilogy(output_set[j][0], abs(psi_d), '-r')
    pyl.subplot(514)
    pyl.xlabel('r')
    pyl.ylabel('dd_r Psi(r)')
    pyl.semilogy(output_set[j][0], abs(psi_dd), '-b')
    pyl.subplot(515)
    pyl.xlabel('r')
    pyl.ylabel('ddd_r Psi(r)')
    pyl.semilogy(output_set[j][0], abs(psi_ddd), '-g')
    pyl.show()
    # end of graphing
