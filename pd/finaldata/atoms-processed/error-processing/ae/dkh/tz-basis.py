import numpy as np

import matplotlib
matplotlib.use('TkAgg')
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt
import os,sys
import pandas as pd

ai = 1.0
bi = 1.0
toev = 27.211386

#def scf_fit(x,*parms):
#        return parms[0] + parms[1]*np.exp(-parms[2]*x)

#def corr_fit(x,*parms):
#        return parms[0]+parms[1]/(x+3./8.)**3 + parms[2]/(x+3./8.)**5
#def corr_fit(x,a,b,c):
#        return a+b/(x+3./8.)**3 + c/(x+3./8.)**5


df=pd.DataFrame()

for basis in ['tz']:
	x = pd.read_csv('./basis/'+basis+'.table1.csv',skip_blank_lines=True,skipinitialspace=True)
	df[basis+'_ccsd'] = x['CCSD']

ccsd = df.filter(regex='ccsd')


##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

hf = pd.DataFrame()


#states=['[Kr]$4d**{10}$','[Kr]$4d**{10}5s**1$','[Kr]$4d**{10}5s**2$','[Kr]$4d**{10}5s**14p**1$', '[Kr]$4d**{10}5s**1$','[Kr]$4d**{10}$','[Kr]$4d**9$','[Kr]$4d**8$','[Ar]$4d**7$','[Kr]$4d**6$','[Kr]$4d**5$','[Kr]$3d**{10}4s**24p**2$']
#hf['States'] = states
#corr['Correlation'] = states



hf['Tz'] = ccsd['tz_ccsd']
hf['bas. Gaps'] = hf['Tz'].values - hf['Tz'].values[0]
#x = pd.read_csv('./numericalHF/num.dat',skip_blank_lines=True)
#hf['Numerical'] = x['SCF']
#hf['Diffs'] = hf['Tz'] - hf['Numerical']
#hf['Num. Gaps'] = hf['Numerical'].values - hf['Numerical'].values[0]
#hf['Gap Diffs'] = (hf['bas. Gaps'] - hf['Num. Gaps'])*toev
#

print(hf.to_latex(index=False))


#corr['extrap'] = corr_extrap
	
	



#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
