###########################
# title:    compareSplineDegree.py
# author:   Kevin M. Rasch
# version:  Python 2.6
#           numpy-1.0
#           scipy-0.9
#           matplotlib - comment out the graphs at the end and use your own 
#                        graphing tool if you dont have this installed
# descrtipion:
# This program collects r, r^(l+1)*phi(r) data from fort.25 produce by the nhf
# code used in the Mitas QMC Group and compares splines of different degree
###########################
# OPTIONAL USER ARGUMENTS
# the following arguments may be passed to python after the sciptname
# 1. unique [int]  -- tells the script how many unique orbitals are in fort.25
#                     otherwise it will use number of states in the nhf calc.
# 2. spline_step [float] -- sets the step size of the output spline
#                           otherwise the longest orbital is divided by 2000
# 3. cusp [int] -- tells the script to fix psi(0) to match the analytic cusp
#            for use in all-electron calculations
###########################
# THE IMPORTS:
from sys import argv
import numpy as np
from scipy.optimize import curve_fit
from scipy.interpolate import UnivariateSpline
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
print "I see",norbs,"states."
if unique_orbs == 0:
    unique_orbs = norbs
cusp = float(-1.0)*float( firstline.split()[1])
print "I see that Z =",-1.0*cusp,"."
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
    print "Symmetry of orb ",j+1," is ",symmetry[j]
    read_x = []
    read_y = []
    for i in range(nextorblength):
        line = spline.readline()
        read_x.append( float(line.split()[1]))
        read_y.append( float(line.split()[2])/ float(line.split()[1])**(1+symmetry[j]) )
    # remove 0.0's up to 1E-6 in phi(r)
    # the end of the tail is expected to approach 0 from the positive side
    while read_y[-1] < 1E-6:
        throwawayx = read_x.pop()
        throwawayy = read_y.pop()
    print "Orb",j+1,"ends at",read_x[-1],read_y[-1]
    # use linear extrapolation to estimate Psi(0)
    yp1 = (read_y[0]-read_y[1])/(read_x[0]-read_x[1])#y prime at first non-0 x
    psi_zero = read_y[0] + yp1*(0.0-read_x[0])
    # if requested, use analytic nuclear cusp to estimate psi_zero via
    #   for s functions D_r(psi) / psi == cusp
    #   for p functions D_r(psi / r) / (psi/r) == cusp/2
    #   for d functions D_r()
    if analytic_nuclear_cusp is True:
        if symmetry[j] is 0:
            print "using s nuclear cusp condition"
            psi_zero = read_y[0] / (1 + cusp*read_x[0])
        if symmetry[j] is 1:
            print "using p nuclear cusp condition"
            psi_zero = 2.0*read_y[0] / (2 + read_x[0]*cusp)
    # insert new point (0.0, psi_zero) into orbital spline
    read_x.insert(0,0.0)
    read_y.insert(0,psi_zero)
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

def tail(x, a, b ):
    return a*np.exp( -b*x )


# loop over stored orbitals, interpolate, and write out
for j in range(unique_orbs):
    print "Preparing orbital ",j+1,"."
    # fit tail of orbital with exponential
    fit_r = np.array(data_set[j][0], dtype=float)
    fit_phi = np.array(data_set[j][1], dtype=float)
    popt, pcov = curve_fit(tail, fit_r, fit_phi)
    # return least-squares fit a,b in popt
    print "Tail is fit by ", popt[0],"*e^{-",popt[1],"x}"
    # return covariance of parameters
    print "covariance",pcov
    t = UnivariateSpline(data_set[j][0], data_set[j][1], k=5, s=0.0)
    outfilename = "orb"+str(j+1)
    output = open(outfilename,'w')
    # build a grid of x values using step size
    k = 0.0
    out_x = []
    while k < data_set[j][0][-1]:
        out_x.append(k)
        k += step_size
    out_y = t(out_x)
    for m in range(len(out_x)):
        line = str(out_x[m])
        line = line+"     "+str(out_y[m])+"\n"
        output.write(line)
    single_orb = []
    single_orb.append(out_x)
    single_orb.append(out_y)
    # store single_orb into data_set
    output_set.append(single_orb)
    # open graphs to show final output
    # comment out below to circumvent graphing
    u = UnivariateSpline(data_set[j][0], data_set[j][1], k=3, s=0.0)
    tpsi     = t(data_set[j][0])
    tpsi_d   = t(data_set[j][0],1)
    tpsi_dd  = t(data_set[j][0],2)
    tpsi_ddd = t(data_set[j][0],3)
    upsi     = u(data_set[j][0])
    upsi_d   = u(data_set[j][0],1)
    upsi_dd  = u(data_set[j][0],2)
    upsi_ddd = u(data_set[j][0],3)
    pyl.close()
    pyl.figure(1)
    pyl.subplot(511)
    pyl.title('Splining of Input mesh, Degree: 3rd(red)  5th(blue)')
    pyl.xlabel('r')
    pyl.ylabel('Psi(r)')
    pyl.semilogy(data_set[j][0], data_set[j][1],'xg')
    pyl.semilogy(data_set[j][0], upsi,'-r')
    pyl.semilogy(data_set[j][0], tpsi, '-b')
    pyl.subplot(512)
    pyl.xlabel('r')
    pyl.ylabel('Psi(r)')    
    pyl.plot(data_set[j][0], data_set[j][1],'xg')
    pyl.plot(data_set[j][0], upsi,'-r')
    pyl.plot(data_set[j][0], tpsi,'-b')
    pyl.subplot(513)
    pyl.xlabel('r')
    pyl.ylabel('d_r Psi(r)')
    pyl.semilogy(data_set[j][0], abs(upsi_d), '-r')
    pyl.semilogy(data_set[j][0], abs(tpsi_d), '-b')
    pyl.subplot(514)
    pyl.xlabel('r')
    pyl.ylabel('dd_r Psi(r)')
    pyl.semilogy(data_set[j][0], abs(upsi_dd), '-r')
    pyl.semilogy(data_set[j][0], abs(tpsi_dd), '-b')
    pyl.subplot(515)
    pyl.xlabel('r')
    pyl.ylabel('ddd_r Psi(r)')
    pyl.semilogy(data_set[j][0], abs(upsi_ddd), '-r')
    pyl.semilogy(data_set[j][0], abs(tpsi_ddd), '-b')
    pyl.show()
    # second set of graphs:  output data
    v = UnivariateSpline(out_x, out_y, k=3, s=0.0) # 3th degree spline
    w = UnivariateSpline(out_x, out_y, k=5, s=0.0) # 5rd degree spline
    vpsi     = v(out_x)
    vpsi_d   = v(out_x,1)
    vpsi_dd  = v(out_x,2)
    vpsi_ddd = v(out_x,3)
    wpsi     = w(out_x)
    wpsi_d   = w(out_x,1)
    wpsi_dd  = w(out_x,2)
    wpsi_ddd = w(out_x,3)
    pyl.close()
    pyl.figure(1)
    pyl.subplot(511)
    pyl.title('Splining of Output, Degree: 3rd(red)  5th(blue)')
    pyl.xlabel('r')
    pyl.ylabel('Psi(r)')
    pyl.semilogy(data_set[j][0], data_set[j][1],'xg')
    pyl.semilogy(output_set[j][0], vpsi,'-r')
    pyl.semilogy(output_set[j][0], wpsi, '-b')
    pyl.subplot(512)
    pyl.xlabel('r')
    pyl.ylabel('Psi(r)')    
    pyl.plot(data_set[j][0], data_set[j][1],'xg')
    pyl.plot(output_set[j][0], vpsi,'-r')
    pyl.plot(output_set[j][0], wpsi,'-b')
    pyl.subplot(513)
    pyl.xlabel('r')
    pyl.ylabel('d_r Psi(r)')
    pyl.semilogy(output_set[j][0], abs(vpsi_d), '-r')
    pyl.semilogy(output_set[j][0], abs(wpsi_d), '-b')
    pyl.subplot(514)
    pyl.xlabel('r')
    pyl.ylabel('dd_r Psi(r)')
    pyl.semilogy(output_set[j][0], abs(vpsi_dd), '-r')
    pyl.semilogy(output_set[j][0], abs(wpsi_dd), '-b')
    pyl.subplot(515)
    pyl.xlabel('r')
    pyl.ylabel('ddd_r Psi(r)')
    pyl.semilogy(output_set[j][0], abs(vpsi_ddd), '-r')
    pyl.semilogy(output_set[j][0], abs(wpsi_ddd), '-b')
    pyl.show()
    # end of graphing
