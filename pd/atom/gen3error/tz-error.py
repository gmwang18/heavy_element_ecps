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

##bk2.1##
df2_1=pd.DataFrame()

for basis in ['tz']:
    a1 = pd.read_csv('./'+basis+'.bk2.1.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_1[basis+'_ccsd'] = a1['CCSD']

bk2_1 = df2_1.filter(regex='ccsd')


##bk2.2##
df2_2=pd.DataFrame()

for basis in ['tz']:
    a2 = pd.read_csv('./'+basis+'.bk2.2.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_2[basis+'_ccsd'] = a2['CCSD']

bk2_2 = df2_2.filter(regex='ccsd')

##bk2.3##
df2_3=pd.DataFrame()

for basis in ['tz']:
    a3 = pd.read_csv('./'+basis+'.bk2.3.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_3[basis+'_ccsd'] = a3['CCSD']

bk2_3 = df2_3.filter(regex='ccsd')

##bk2.4##
df2_4=pd.DataFrame()

for basis in ['tz']:
    a4 = pd.read_csv('./'+basis+'.bk2.4.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_4[basis+'_ccsd'] = a4['CCSD']

bk2_4 = df2_4.filter(regex='ccsd')

##bk2.5##
df2_5=pd.DataFrame()

for basis in ['tz']:
    a5 = pd.read_csv('./'+basis+'.bk2.5.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_5[basis+'_ccsd'] = a5['CCSD']

bk2_5 = df2_5.filter(regex='ccsd')

##bk2.6##
df2_6=pd.DataFrame()

for basis in ['tz']:
    a6 = pd.read_csv('./'+basis+'.bk2.6.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_6[basis+'_ccsd'] = a6['CCSD']

bk2_6 = df2_6.filter(regex='ccsd')

##bk2.7##
df2_7=pd.DataFrame()

for basis in ['tz']:
    a7 = pd.read_csv('./'+basis+'.bk2.7.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_7[basis+'_ccsd'] = a7['CCSD']

bk2_7 = df2_7.filter(regex='ccsd')

##bk2.8##
df2_8=pd.DataFrame()

for basis in ['tz']:
    a8 = pd.read_csv('./'+basis+'.bk2.8.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_8[basis+'_ccsd'] = a8['CCSD']

bk2_8 = df2_8.filter(regex='ccsd')

##bk2.9##
df2_9=pd.DataFrame()

for basis in ['tz']:
    a9 = pd.read_csv('./'+basis+'.bk2.9.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_9[basis+'_ccsd'] = a9['CCSD']

bk2_9 = df2_9.filter(regex='ccsd')

##bk4.1##
df4_1=pd.DataFrame()

for basis in ['tz']:
    a41 = pd.read_csv('./'+basis+'.bk4.1.csv',skip_blank_lines=True,skipinitialspace=True)
    df4_1[basis+'_ccsd'] = a41['CCSD']

bk4_1 = df4_1.filter(regex='ccsd')

##bk5.1##
df5_1=pd.DataFrame()

for basis in ['tz']:
    a51 = pd.read_csv('./'+basis+'.bk5.1.csv',skip_blank_lines=True,skipinitialspace=True)
    df5_1[basis+'_ccsd'] = a51['CCSD']

bk5_1 = df5_1.filter(regex='ccsd')

##bk6.1##
df6_1=pd.DataFrame()

for basis in ['tz']:
    a61 = pd.read_csv('./'+basis+'.bk6.1.csv',skip_blank_lines=True,skipinitialspace=True)
    df6_1[basis+'_ccsd'] = a61['CCSD']

bk6_1 = df6_1.filter(regex='ccsd')

##bk7.1##
df7_1=pd.DataFrame()

for basis in ['tz']:
    a71 = pd.read_csv('./'+basis+'.bk7.1.csv',skip_blank_lines=True,skipinitialspace=True)
    df7_1[basis+'_ccsd'] = a71['CCSD']

bk7_1 = df7_1.filter(regex='ccsd')

##bk8.1##
df8_1=pd.DataFrame()

for basis in ['tz']:
    a81 = pd.read_csv('./'+basis+'.bk8.1.csv',skip_blank_lines=True,skipinitialspace=True)
    df8_1[basis+'_ccsd'] = a81['CCSD']

bk8_1 = df8_1.filter(regex='ccsd')


##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

ff = pd.DataFrame()


#states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
#hf['SCF'] = states
#corr['Correlation'] = states



ff['all electron'] = ae['tz_ccsd']
ff['ae gaps'] = ff['all electron'].values - ff['all electron'].values[0] 
ff['MDFSTU'] = stu['tz_ccsd']
ff['MDFSTU gaps'] = ff['MDFSTU'].values - ff['MDFSTU'].values[0]
#ff['bk2.1'] = bk2_1['tz_ccsd']
#ff['bk2.1 gaps'] = ff['bk2.1'].values - ff['bk2.1'].values[0]
#ff['bk2.2'] = bk2_2['tz_ccsd'] 
#ff['bk2.2 gaps'] = ff['bk2.2'].values - ff['bk2.2'].values[0]
#ff['bk2.3'] = bk2_3['tz_ccsd'] 
#ff['bk2.3 gaps'] = ff['bk2.3'].values - ff['bk2.3'].values[0]
#ff['bk2.4'] = bk2_4['tz_ccsd'] 
#ff['bk2.4 gaps'] = ff['bk2.4'].values - ff['bk2.4'].values[0]
#ff['bk2.5'] = bk2_5['tz_ccsd'] 
#ff['bk2.5 gaps'] = ff['bk2.5'].values - ff['bk2.5'].values[0]
#ff['bk2.6'] = bk2_6['tz_ccsd'] 
#ff['bk2.6 gaps'] = ff['bk2.6'].values - ff['bk2.6'].values[0]
#ff['bk2.7'] = bk2_7['tz_ccsd'] 
#ff['bk2.7 gaps'] = ff['bk2.7'].values - ff['bk2.7'].values[0]
#ff['bk2.8'] = bk2_8['tz_ccsd'] 
#ff['bk2.8 gaps'] = ff['bk2.8'].values - ff['bk2.8'].values[0]
#ff['bk2.9'] = bk2_9['tz_ccsd'] 
#ff['bk2.9 gaps'] = ff['bk2.9'].values - ff['bk2.9'].values[0]
ff['bk4.1'] = bk4_1['tz_ccsd'] 
ff['bk4.1 gaps'] = ff['bk4.1'].values - ff['bk4.1'].values[0]
ff['bk5.1'] = bk5_1['tz_ccsd'] 
ff['bk5.1 gaps'] = ff['bk5.1'].values - ff['bk5.1'].values[0]
ff['bk6.1'] = bk6_1['tz_ccsd'] 
ff['bk6.1 gaps'] = ff['bk6.1'].values - ff['bk6.1'].values[0]
ff['bk7.1'] = bk7_1['tz_ccsd'] 
ff['bk7.1 gaps'] = ff['bk7.1'].values - ff['bk7.1'].values[0]
ff['bk8.1'] = bk8_1['tz_ccsd'] 
ff['bk8.1 gaps'] = ff['bk8.1'].values - ff['bk8.1'].values[0]

fff = pd.DataFrame()
fff['all electron'] = ff['ae gaps'].values*toev
fff['MDFSTU'] = ff['MDFSTU gaps'].values*toev
#fff['bk2.1'] = ff['bk2.1 gaps'].values*toev
#fff['bk2.2'] = ff['bk2.2 gaps'].values*toev
#fff['bk2.3'] = ff['bk2.3 gaps'].values*toev
#fff['bk2.4'] = ff['bk2.4 gaps'].values*toev
#fff['bk2.5'] = ff['bk2.5 gaps'].values*toev
#fff['bk2.6'] = ff['bk2.6 gaps'].values*toev
#fff['bk2.7'] = ff['bk2.7 gaps'].values*toev
#fff['bk2.8'] = ff['bk2.8 gaps'].values*toev
#fff['bk2.9'] = ff['bk2.9 gaps'].values*toev
fff['bk4.1'] = ff['bk4.1 gaps'].values*toev
fff['bk5.1'] = ff['bk5.1 gaps'].values*toev
fff['bk6.1'] = ff['bk6.1 gaps'].values*toev
fff['bk7.1'] = ff['bk7.1 gaps'].values*toev
fff['bk8.1'] = ff['bk8.1 gaps'].values*toev


er = pd.DataFrame()
er['MDFSTU error'] = fff['MDFSTU'].values - fff['all electron'].values
#er['bk2.1 error'] = fff['bk2.1'].values - fff['all electron'].values
#er['bk2.2 error'] = fff['bk2.2'].values - fff['all electron'].values
#er['bk2.3 error'] = fff['bk2.3'].values - fff['all electron'].values
#er['bk2.4 error'] = fff['bk2.4'].values - fff['all electron'].values
#er['bk2.5 error'] = fff['bk2.5'].values - fff['all electron'].values
#er['bk2.6 error'] = fff['bk2.6'].values - fff['all electron'].values
#er['bk2.7 error'] = fff['bk2.7'].values - fff['all electron'].values
#er['bk2.8 error'] = fff['bk2.8'].values - fff['all electron'].values
#er['bk2.9 error'] = fff['bk2.9'].values - fff['all electron'].values
er['bk4.1 error'] = fff['bk4.1'].values - fff['all electron'].values
er['bk5.1 error'] = fff['bk5.1'].values - fff['all electron'].values
er['bk6.1 error'] = fff['bk6.1'].values - fff['all electron'].values
er['bk7.1 error'] = fff['bk7.1'].values - fff['all electron'].values
er['bk8.1 error'] = fff['bk8.1'].values - fff['all electron'].values

mads = er.mad(axis=0)











print(mads.to_latex(index=False))


print(er.to_latex(index=False))

print(fff.to_latex(index=False))
	
	



#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
