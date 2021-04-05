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

##all electron##
dfae=pd.DataFrame()

for basis in ['tz']:
	a = pd.read_csv('./'+basis+'.ae.csv',skip_blank_lines=True,skipinitialspace=True)
	dfae[basis+'_ccsd'] = a['CCSD']

ae = dfae.filter(regex='ccsd')

##UC##
dfuc=pd.DataFrame()

for basis in ['tz']:
	uc = pd.read_csv('./'+basis+'.UC.csv',skip_blank_lines=True,skipinitialspace=True)
	dfuc[basis+'_ccsd'] = uc['CCSD']

bkuc = dfuc.filter(regex='ccsd')

##Stuttgart##
dfstu=pd.DataFrame()

for basis in ['tz']:
	b = pd.read_csv('./'+basis+'.mdfstu.csv',skip_blank_lines=True,skipinitialspace=True)
	dfstu[basis+'_ccsd'] = b['CCSD']

stu = dfstu.filter(regex='ccsd')

##CRENBL##
dfcren=pd.DataFrame()

for basis in ['tz']:
	cren = pd.read_csv('./'+basis+'.CRENBL.csv',skip_blank_lines=True,skipinitialspace=True)
	dfcren[basis+'_ccsd'] = cren['CCSD']

bkcren = dfcren.filter(regex='ccsd')

##LANL2##
dflanl2=pd.DataFrame()

for basis in ['tz']:
	lanl2 = pd.read_csv('./'+basis+'.LANL2.csv',skip_blank_lines=True,skipinitialspace=True)
	dflanl2[basis+'_ccsd'] = lanl2['CCSD']

bklanl2 = dflanl2.filter(regex='ccsd')

##SBKJC##
dfsbkjc=pd.DataFrame()

for basis in ['tz']:
	sbkjc = pd.read_csv('./'+basis+'.SBKJC.csv',skip_blank_lines=True,skipinitialspace=True)
	dfsbkjc[basis+'_ccsd'] = sbkjc['CCSD']

bksbkjc = dfsbkjc.filter(regex='ccsd')

##ccECP##
dfccecp=pd.DataFrame()

for basis in ['tz']:
	ccecp = pd.read_csv('./'+basis+'.ccECP.csv',skip_blank_lines=True,skipinitialspace=True)
	dfccecp[basis+'_ccsd'] = ccecp['CCSD']

bkccecp = dfccecp.filter(regex='ccsd')

##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

ff = pd.DataFrame()


#states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
#hf['SCF'] = states
#corr['Correlation'] = states



ff['all electron'] = ae['tz_ccsd']
ff['ae gaps'] = ff['all electron'].values - ff['all electron'].values[0] 
ff['UC'] = dfuc['tz_ccsd']
ff['UC gaps'] = ff['UC'].values - ff['UC'].values[0]
ff['MDFSTU'] = stu['tz_ccsd']
ff['MDFSTU gaps'] = ff['MDFSTU'].values - ff['MDFSTU'].values[0]
ff['CRENBL'] = dfcren['tz_ccsd']
ff['CRENBL gaps'] = ff['CRENBL'].values - ff['CRENBL'].values[0]
ff['LANL2'] = dflanl2['tz_ccsd']
ff['LANL2 gaps'] = ff['LANL2'].values - ff['LANL2'].values[0]
ff['SBKJC'] = dfsbkjc['tz_ccsd']
ff['SBKJC gaps'] = ff['SBKJC'].values - ff['SBKJC'].values[0]
ff['ccECP'] = dfccecp['tz_ccsd']
ff['ccECP gaps'] = ff['ccECP'].values - ff['ccECP'].values[0]


fff = pd.DataFrame()
fff['all electron'] = ff['ae gaps'].values*toev
fff['UC'] = ff['UC gaps'].values*toev
fff['MDFSTU'] = ff['MDFSTU gaps'].values*toev
fff['CRENBL'] = ff['CRENBL gaps'].values*toev
fff['LANL2'] = ff['LANL2 gaps'].values*toev
fff['SBKJC'] = ff['SBKJC gaps'].values*toev
fff['ccECP'] = ff['ccECP gaps'].values*toev

er = pd.DataFrame()
er['UC error'] = fff['UC'].values - fff['all electron'].values
er['MDFSTU error'] = fff['MDFSTU'].values - fff['all electron'].values
er['CRENBL error'] = fff['CRENBL'].values - fff['all electron'].values
er['LANL2 error'] = fff['LANL2'].values - fff['all electron'].values
er['SBKJC error'] = fff['SBKJC'].values - fff['all electron'].values
er['ccECP error'] = fff['ccECP'].values - fff['all electron'].values


mads = er.mad(axis=0)

weight_er = pd.DataFrame()

weight_er['UC error'] = (fff['UC'].values - fff['all electron'].values)/fff['all electron'].values
weight_er['MDFSTU error'] = (fff['MDFSTU'].values - fff['all electron'].values)/fff['all electron'].values
weight_er['CRENBL error'] = (fff['CRENBL'].values - fff['all electron'].values)/fff['all electron'].values
weight_er['LANL2 error'] = (fff['LANL2'].values - fff['all electron'].values)/fff['all electron'].values
weight_er['SBKJC error'] = (fff['SBKJC'].values - fff['all electron'].values)/fff['all electron'].values
weight_er['ccECP error'] = (fff['ccECP'].values - fff['all electron'].values)/fff['all electron'].values

weight_mads = weight_er.mad(axis=0)


#opt = pd.DataFrame()
#opt['ae gaps'] = fff['all electron'].values
#opt['bk1.2 corr'] = ff['bk1.2 corr'].values*toev
#opt['bk1.2 opt'] = opt['ae gaps'].values - opt['bk1.2 corr']
#opt['bk1.3 corr'] = ff['bk1.3 corr'].values*toev
#opt['bk1.3 opt'] = opt['ae gaps'].values - opt['bk1.3 corr']







#print(mads.to_latex(index=False))


print(er.to_latex(index=False))
print(mads.to_latex(index=False))

#print(weight_er.to_latex(index=False))
print(weight_mads.to_latex(index=False))
	
	



#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
