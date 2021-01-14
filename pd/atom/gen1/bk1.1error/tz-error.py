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


dfae=pd.DataFrame()

for basis in ['tz']:
	x = pd.read_csv('./'+basis+'.ae.csv',skip_blank_lines=True,skipinitialspace=True)
	dfae[basis+'_ccsd'] = x['CCSD']

ae = dfae.filter(regex='ccsd')

dfstu=pd.DataFrame()

for basis in ['tz']:
	y = pd.read_csv('./'+basis+'.bk1.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfstu[basis+'_ccsd'] = y['CCSD']

stu = dfstu.filter(regex='ccsd')

hfstu=pd.DataFrame()

for basis in ['tz']:
        z = pd.read_csv('./'+basis+'.bk1.1.csv',skip_blank_lines=True,skipinitialspace=True)
        hfstu[basis+'_scf'] = z['SCF']

hf = hfstu.filter(regex='scf')

##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

ff = pd.DataFrame()


#states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
#hf['SCF'] = states
#corr['Correlation'] = states



ff['all electron'] = ae['tz_ccsd']
ff['ae gaps'] = ff['all electron'].values - ff['all electron'].values[0] 
ff['bk1.1'] = stu['tz_ccsd']
#ff['bk1.1 SCF'] = hf['tz_scf'] 
ff['bk1.1 gaps'] = ff['bk1.1'].values - ff['bk1.1'].values[0]
#ff['ECP corr. gaps'] = ff['bk1.1 gaps'] - (ff['bk1.1 SCF'].values - ff['bk1.1 SCF'].values[0])
#ff['opt'] = (ff['ae gaps'] - ff['ECP corr. gaps'])*toev
ff['Error'] = ff['ae gaps'] - ff['bk1.1 gaps']
#ff['ECP_corr'] = ff['bk1.1'] - ff['bk1.1 SCF']
#ff['ECP corr gaps'] = ff['ECP_corr'] - ff['ECP_corr'].values[0]
#ff['opt2'] = (ff['ae gaps'] - ff['ECP corr gaps'])*toev



#ff['Error eV'] = ff['Error']*toev
#x = pd.read_csv('./numericalHF/num.dat',skip_blank_lines=True)
#hf['Numerical'] = x['SCF']
#hf['Diffs'] = hf['Tz'] - hf['Numerical']
#hf['Num. Gaps'] = hf['Numerical'].values - hf['Numerical'].values[0]
#hf['Gap Diffs'] = (hf['bas. Gaps'] - hf['Num. Gaps'])*toev
#

print(ff.to_latex(index=False))


#corr['extrap'] = corr_extrap
	
	



#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
