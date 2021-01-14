#!/usr/bin/env python


###########################
# title:    plot-orb.py
# author:   Guangming Wang
# version:  Python 3.7
#           matplotlib - comment out the graphs at the end and use your own 
#                        graphing tool if you dont have this installed
# descrtipion:
# This program collects r, r^(l+1)*phi(r) data from fort.25 
# and plot the r^(l+1)*phi(r) and electron probablity (r^(l+1)*phi(r))^2
# print out the radii, namely, the average radius of the orbitals
###########################
# To use:  
#     1. If it's your first time to use it, you need to install the package inflect.
#        To install, do 'pip install inflect'
#     2. simply run 'python plot-orb.py'
#     3. The script will ask you what radius you want to choose, you can hit ENTER to skip it.
#        (be sure the radius you want to plot is between the radius range, usually 0 to about 90)

import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd
import sys
import os
import inflect

p = inflect.engine()

pd.set_option("display.precision", 17)


### Define the orbital symbol here ###
def orb_sym(x):
    x = int(x)
    if x == 0:
        symbol = 's'
    elif x == 1:
        symbol = 'p'
    elif x == 2:
        symbol = 'd'
    elif x == 3:
        symbol = 'f'
    elif x == 4:
        symbol = 'g'
    return symbol

### count the occurence of orbitals and give the order of it ###
def orb_name(orblist):
    orbnames = []
    for i in range(len(orblist)):
        occurrence = orblist[:i].count(orblist[i])
        orbnames.append(p.ordinal(occurrence+1)+'_'+orb_sym(orblist[i]))
    return orbnames

### Read each orbitals ###
def read_orbs():
    orblist = []
    with open('fort.25', 'r') as fhand:
        for line in fhand.readlines():
# Each orbitals have 2000 points of radius and data points 
# Read to check how many orbitals are there.
             if len(line.split()) == 2 and line.split()[0] == '2000':
                 orblist.append(line.split()[1])
                 #while count
    fhand.close()
    
    orbnames = orb_name(orblist)
    
    df = pd.DataFrame()
    count = 0 
    radius = []
    rrho = []
    columns = 0
### Read the r^(l+1)*rho orbitals
    with open('fort.25', 'r') as fhand:
        for line in fhand.readlines():
            if len(line.split()) > 2 and line.split()[0] == '1':
                count = 1
                radius = []
                rrho = []
            if count > 0 and count <= 2000:
                radius.append(np.float(line.split()[1]))
                rrho.append(np.float(line.split()[2]))
                count += 1
            if len(radius) == 2000 and len(line.split()) > 2:
                df['radius'] = radius
                df[orbnames[columns]] = rrho
                columns += 1
    fhand.close()
    return orbnames,df



def plot_rrho(orbnames,df,r):
    for orb in orbnames:
        plt.plot(df['radius'],df[orb],label=orb)
        plt.legend(prop={'size': 15})
        plt.xlim(0,r)
    plt.title(r'$r^{l+1}\psi$ vs r')
    plt.xlabel('radius')
    plt.ylabel(r'$r^{l+1}\psi$')
    plt.show()
    return 0

def plot_e_probability(orbnames,df,r):
    for orb in orbnames:
        plt.plot(df['radius'],df[orb]**2,label=orb)
        plt.legend(prop={'size': 15})
        plt.xlim(0,r)
    plt.title(r'radial electron probability $(r^{l+1}\psi)^2$ vs r')
    plt.xlabel('radius')
    plt.ylabel('electron probability $(r^{l+1}\psi)^2$')
    plt.show()
    return 0

### Print the radii, namely, the avaerage radius ###
def radii(orbnames,df):
    average_radii = []
    for orb in orbnames:
        rad = sum(df['radius']*df[orb]**2)/sum(df[orb]**2)
        average_radii.append(rad)
        print(orb,'average radii is: ',f"{rad:.6f}")
    return average_radii


if __name__ == '__main__':
    
    r = input("Enter the radius upper limit for your plot (default is 7): ")   

    if r.isspace() or r == '':
        r = 7
    else:
        r = np.float(r)

    orbnames,df = read_orbs()
    radii(orbnames,df)

    plot_rrho(orbnames,df,r)
    plot_e_probability(orbnames,df,r)


