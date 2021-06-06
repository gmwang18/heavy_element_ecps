#! /usr/bin/env python

import sys,os
import matplotlib
matplotlib.use('TkAgg')
import pandas as pd
from scipy.optimize import curve_fit
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt


toev = 27.211386

#~~~Analyze Binding Energy~~~~~

def morse(x,D,a,re):
	y=D*(np.exp(-2*a*(x-re))-2*np.exp(-a*(x-re)))
	return y

binding = pd.read_csv("tzbind", delim_whitespace=True)
print (binding)
#binding = binding.drop([0]).reset_index(drop=True)
#print binding


initial=[min(binding['bind']), 2.0, binding['r'].loc[0]/0.7 ]
popt_m, pcov_m = curve_fit(morse, binding['r'], binding['bind'], p0=initial)
print ("popt_m:")
print (popt_m)
print ("STD:")
print (np.sqrt(np.diag(pcov_m)))

print ("D_e (eV):")
print (popt_m[0]*toev)
print ("r (A):")
print (popt_m[-1])
print ("Dissociation r:")
print ((popt_m[2]-np.log(2)/popt_m[1]))

x = np.linspace(1.6,2.2,100)
plt.plot(binding['r'], binding['bind'], 'r*')
plt.plot(x, morse(x,*popt_m))
plt.xlim(1.65,2.25)
plt.show()
