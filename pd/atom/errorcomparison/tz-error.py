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


##Stuttgart##
dfstu=pd.DataFrame()

for basis in ['tz']:
	b = pd.read_csv('./'+basis+'.mdfstu.csv',skip_blank_lines=True,skipinitialspace=True)
        dfstu[basis+'_ccsd'] = b['CCSD']

stu = dfstu.filter(regex='ccsd')

##bk1.0##
df0=pd.DataFrame()

for basis in ['tz']:
    c = pd.read_csv('./'+basis+'.bk1.0.csv',skip_blank_lines=True,skipinitialspace=True)
    df0[basis+'_ccsd'] = c['CCSD']

bk0 = df0.filter(regex='ccsd')



#scf0=pd.DataFrame()
#
#for basis in ['Tz']:
#    h = pd.read_csv('./'+basis+'.bk1.0.csv',skip_blank_lines=True,skipinitialspace=True)
#    scf0[basis+'_scf'] = h['SCF']



##bk1.1##

df1=pd.DataFrame()

for basis in ['tz']:
    d = pd.read_csv('./'+basis+'.bk1.1.csv',skip_blank_lines=True,skipinitialspace=True)
    df1[basis+'_ccsd'] = d['CCSD']

bk1 = df1.filter(regex='ccsd')



#scf1=pd.DataFrame()
#
#for basis in ['Tz']:
#    i = pd.read_csv('./'+basis+'.bk1.1.csv',skip_blank_lines=True,skipinitialspace=True)
#    scf1[basis+'_scf'] = i['SCF']

##bk1.2##

df2=pd.DataFrame()

for basis in ['tz']:
    e = pd.read_csv('./'+basis+'.bk1.2.csv',skip_blank_lines=True,skipinitialspace=True)
    df2[basis+'_ccsd'] = e['CCSD']

bk2 = df2.filter(regex='ccsd')


scf2=pd.DataFrame()

for basis in ['tz']:
    j = pd.read_csv('./'+basis+'.bk1.2.csv',skip_blank_lines=True,skipinitialspace=True)
    scf2[basis+'_scf'] = j['SCF']



##bk1.3##

df3=pd.DataFrame()

for basis in ['tz']:
    f = pd.read_csv('./'+basis+'.bk1.3.csv',skip_blank_lines=True,skipinitialspace=True)
    df3[basis+'_ccsd'] = f['CCSD']

bk3 = df3.filter(regex='ccsd')


scf3=pd.DataFrame()

for basis in ['tz']:
    k = pd.read_csv('./'+basis+'.bk1.3.csv',skip_blank_lines=True,skipinitialspace=True)
    scf3[basis+'_scf'] = k['SCF']



##bk1.4##

df4=pd.DataFrame()

for basis in ['tz']:
    g = pd.read_csv('./'+basis+'.bk1.4.csv',skip_blank_lines=True,skipinitialspace=True)
    df4[basis+'_ccsd'] = g['CCSD']

bk4 = df4.filter(regex='ccsd')

##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

ff = pd.DataFrame()


#states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
#hf['SCF'] = states
#corr['Correlation'] = states



ff['all electron'] = ae['tz_ccsd']
ff['ae gaps'] = ff['all electron'].values - ff['all electron'].values[0] 
#ff['MDFSTU'] = stu['tz_ccsd']
#ff['MDFSTU gaps'] = ff['MDFSTU'].values - ff['MDFSTU'].values[0]
ff['bk1.0'] = df0['tz_ccsd']
ff['bk1.0 gaps'] = ff['bk1.0'].values - ff['bk1.0'].values[0]
ff['bk1.1'] = df1['tz_ccsd'] 
ff['bk1.1 gaps'] = ff['bk1.1'].values - ff['bk1.1'].values[0]
ff['bk1.2'] = df2['tz_ccsd'] 
ff['bk1.2 gaps'] = ff['bk1.2'].values - ff['bk1.2'].values[0]
ff['bk1.2 corr'] = ff['bk1.2 gaps'].values - (scf2['tz_scf'].values - scf2['tz_scf'].values[0])
ff['bk1.3'] = df3['tz_ccsd']
ff['bk1.3 gaps'] = ff['bk1.3'].values - ff['bk1.3'].values[0]
ff['bk1.3 corr'] = ff['bk1.3 gaps'].values - (scf3['tz_scf'].values - scf3['tz_scf'].values[0])
ff['bk1.3 gaps'] = ff['bk1.3'].values - ff['bk1.3'].values[0]
ff['bk1.4'] = df4['tz_ccsd'] 
ff['bk1.4 gaps'] = ff['bk1.4'].values - ff['bk1.4'].values[0]









fff = pd.DataFrame()
fff['all electron'] = ff['ae gaps'].values*toev
#fff['MDFSTU'] = ff['MDFSTU gaps'].values*toev
fff['bk1.0'] = ff['bk1.0 gaps'].values*toev
fff['bk1.1'] = ff['bk1.1 gaps'].values*toev
fff['bk1.2'] = ff['bk1.2 gaps'].values*toev
fff['bk1.3'] = ff['bk1.3 gaps'].values*toev
fff['bk1.4'] = ff['bk1.4 gaps'].values*toev

er = pd.DataFrame()
#er['MDFSTU error'] = fff['MDFSTU'].values - fff['all electron'].values
er['bk1.0 error'] = fff['bk1.0'].values - fff['all electron'].values
er['bk1.1 error'] = fff['bk1.1'].values - fff['all electron'].values
er['bk1.2 error'] = fff['bk1.2'].values - fff['all electron'].values
er['bk1.3 error'] = fff['bk1.3'].values - fff['all electron'].values
er['bk1.4 error'] = fff['bk1.4'].values - fff['all electron'].values


mads = er.mad(axis=0)


opt = pd.DataFrame()
opt['ae gaps'] = fff['all electron'].values
opt['bk1.2 corr'] = ff['bk1.2 corr'].values*toev
opt['bk1.2 opt'] = opt['ae gaps'].values - opt['bk1.2 corr']
opt['bk1.3 corr'] = ff['bk1.3 corr'].values*toev
opt['bk1.3 opt'] = opt['ae gaps'].values - opt['bk1.3 corr']







#print(mads.to_latex(index=False))


#print(er.to_latex(index=False))

print(opt.to_latex(index=False))
	
	



#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
