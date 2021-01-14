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

aescf=pd.DataFrame()

for basis in ['tz']:
    a01 = pd.read_csv('./'+basis+'.ae.csv',skip_blank_lines=True,skipinitialspace=True)
    aescf[basis+'_scf'] = a01['SCF']

##Stuttgart##
dfstu=pd.DataFrame()

for basis in ['tz']:
	b = pd.read_csv('./'+basis+'.mdfstu.csv',skip_blank_lines=True,skipinitialspace=True)
        dfstu[basis+'_ccsd'] = b['CCSD']

stu = dfstu.filter(regex='ccsd')


stuscf=pd.DataFrame()

for basis in ['tz']:
    a0 = pd.read_csv('./'+basis+'.mdfstu.csv',skip_blank_lines=True,skipinitialspace=True)
    stuscf[basis+'_scf'] = a0['SCF']


##bk2.8##
df0=pd.DataFrame()

for basis in ['tz']:
    c = pd.read_csv('./'+basis+'.bk2.8.csv',skip_blank_lines=True,skipinitialspace=True)
    df0[basis+'_ccsd'] = c['CCSD']

bk0 = df0.filter(regex='ccsd')



scf0=pd.DataFrame()

for basis in ['tz']:
    h = pd.read_csv('./'+basis+'.bk2.8.csv',skip_blank_lines=True,skipinitialspace=True)
    scf0[basis+'_scf'] = h['SCF']

##bk2.10##

df2_10=pd.DataFrame()

for basis in ['tz']:
    a10 = pd.read_csv('./'+basis+'.bk2.10.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_10[basis+'_ccsd'] = a10['CCSD']

bk2_10 = df2_10.filter(regex='ccsd')



scf2_10=pd.DataFrame()

for basis in ['tz']:
    b10 = pd.read_csv('./'+basis+'.bk2.10.csv',skip_blank_lines=True,skipinitialspace=True)
    scf2_10[basis+'_scf'] = b10['SCF']

##bk2.11##

df2_11=pd.DataFrame()

for basis in ['tz']:
    a11 = pd.read_csv('./'+basis+'.bk2.11.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_11[basis+'_ccsd'] = a11['CCSD']

bk2_11 = df2_11.filter(regex='ccsd')



scf2_11=pd.DataFrame()

for basis in ['tz']:
    b11 = pd.read_csv('./'+basis+'.bk2.11.csv',skip_blank_lines=True,skipinitialspace=True)
    scf2_11[basis+'_scf'] = b11['SCF']

##bk2.12##

df2_12=pd.DataFrame()

for basis in ['tz']:
    a12 = pd.read_csv('./'+basis+'.bk2.12.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_12[basis+'_ccsd'] = a12['CCSD']

bk2_12 = df2_12.filter(regex='ccsd')



scf2_12=pd.DataFrame()

for basis in ['tz']:
    b12 = pd.read_csv('./'+basis+'.bk2.12.csv',skip_blank_lines=True,skipinitialspace=True)
    scf2_12[basis+'_scf'] = b12['SCF']

##bk2.13##

df2_13=pd.DataFrame()

for basis in ['tz']:
    a13 = pd.read_csv('./'+basis+'.bk2.13.csv',skip_blank_lines=True,skipinitialspace=True)
    df2_13[basis+'_ccsd'] = a13['CCSD']

bk2_13 = df2_13.filter(regex='ccsd')



scf2_13=pd.DataFrame()

for basis in ['tz']:
    b13 = pd.read_csv('./'+basis+'.bk2.13.csv',skip_blank_lines=True,skipinitialspace=True)
    scf2_13[basis+'_scf'] = b13['SCF']

##bk4.1##

df4_1=pd.DataFrame()

for basis in ['tz']:
    a41 = pd.read_csv('./'+basis+'.bk4.1.csv',skip_blank_lines=True,skipinitialspace=True)
    df4_1[basis+'_ccsd'] = a41['CCSD']

bk4_1 = df4_1.filter(regex='ccsd')



scf4_1=pd.DataFrame()

for basis in ['tz']:
    b41 = pd.read_csv('./'+basis+'.bk4.1.csv',skip_blank_lines=True,skipinitialspace=True)
    scf4_1[basis+'_scf'] = b41['SCF']

##bk5.1##

df5_1=pd.DataFrame()

for basis in ['tz']:
    a51 = pd.read_csv('./'+basis+'.bk5.1.csv',skip_blank_lines=True,skipinitialspace=True)
    df5_1[basis+'_ccsd'] = a51['CCSD']

bk5_1 = df5_1.filter(regex='ccsd')



scf5_1=pd.DataFrame()

for basis in ['tz']:
    b51 = pd.read_csv('./'+basis+'.bk5.1.csv',skip_blank_lines=True,skipinitialspace=True)
    scf5_1[basis+'_scf'] = b51['SCF']

##reg1##

dfreg1=pd.DataFrame()

for basis in ['tz']:
    r1 = pd.read_csv('./'+basis+'.reg1.csv',skip_blank_lines=True,skipinitialspace=True)
    dfreg1[basis+'_ccsd'] = r1['CCSD']

reg1 = dfreg1.filter(regex='ccsd')



scfreg1=pd.DataFrame()

for basis in ['tz']:
    s1 = pd.read_csv('./'+basis+'.reg1.csv',skip_blank_lines=True,skipinitialspace=True)
    scfreg1[basis+'_scf'] = s1['SCF']

##reg2##

dfreg2=pd.DataFrame()

for basis in ['tz']:
    r2 = pd.read_csv('./'+basis+'.reg2.csv',skip_blank_lines=True,skipinitialspace=True)
    dfreg2[basis+'_ccsd'] = r2['CCSD']

reg2 = dfreg2.filter(regex='ccsd')



scfreg2=pd.DataFrame()

for basis in ['tz']:
    s2 = pd.read_csv('./'+basis+'.reg2.csv',skip_blank_lines=True,skipinitialspace=True)
    scfreg2[basis+'_scf'] = s2['SCF']

##reg3##

dfreg3=pd.DataFrame()

for basis in ['tz']:
    r3 = pd.read_csv('./'+basis+'.reg3.csv',skip_blank_lines=True,skipinitialspace=True)
    dfreg3[basis+'_ccsd'] = r3['CCSD']

reg3 = dfreg3.filter(regex='ccsd')



scfreg3=pd.DataFrame()

for basis in ['tz']:
    s3 = pd.read_csv('./'+basis+'.reg3.csv',skip_blank_lines=True,skipinitialspace=True)
    scfreg3[basis+'_scf'] = s3['SCF']


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



##bk1.5##

df5=pd.DataFrame()

for basis in ['tz']:
    l = pd.read_csv('./'+basis+'.bk1.5.csv',skip_blank_lines=True,skipinitialspace=True)
    df5[basis+'_ccsd'] = l['CCSD']

bk5 = df5.filter(regex='ccsd')



scf5=pd.DataFrame()

for basis in ['tz']:
    m = pd.read_csv('./'+basis+'.bk1.5.csv',skip_blank_lines=True,skipinitialspace=True)
    scf5[basis+'_scf'] = k['SCF']





##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

ff = pd.DataFrame()


#states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
#hf['SCF'] = states
#corr['Correlation'] = states



ff['all electron'] = ae['tz_ccsd']
#ff['all scf'] = aescf['tz_scf']
ff['ae gaps'] = ff['all electron'].values - ff['all electron'].values[0] 
ff['MDFSTU'] = stu['tz_ccsd']
ff['MDFSTU gaps'] = ff['MDFSTU'].values - ff['MDFSTU'].values[0]
ff['MDFSTU corr'] = ff['MDFSTU gaps'].values - (stuscf['tz_scf'].values - stuscf['tz_scf'].values[0])
#ff['bk2.8'] = df0['tz_ccsd']
#ff['bk2.8 gaps'] = ff['bk2.8'].values - ff['bk2.8'].values[0]
#ff['bk2.8 corr'] = ff['bk2.8 gaps'].values - (scf0['tz_scf'].values - scf0['tz_scf'].values[0])
#ff['bk2.10'] = df2_10['tz_ccsd']
#ff['bk2.10 gaps'] = ff['bk2.10'].values - ff['bk2.10'].values[0]
#ff['bk2.10 corr'] = ff['bk2.10 gaps'].values - (scf2_10['tz_scf'].values - scf2_10['tz_scf'].values[0])
#ff['bk2.11'] = df2_11['tz_ccsd']
#ff['bk2.11 gaps'] = ff['bk2.11'].values - ff['bk2.11'].values[0]
#ff['bk2.11 corr'] = ff['bk2.11 gaps'].values - (scf2_11['tz_scf'].values - scf2_11['tz_scf'].values[0])
#ff['bk2.12'] = df2_12['tz_ccsd']
#ff['bk2.12 gaps'] = ff['bk2.12'].values - ff['bk2.12'].values[0]
#ff['bk2.12 corr'] = ff['bk2.12 gaps'].values - (scf2_12['tz_scf'].values - scf2_12['tz_scf'].values[0])
#ff['bk2.13'] = df2_13['tz_ccsd']
#ff['bk2.13 gaps'] = ff['bk2.13'].values - ff['bk2.13'].values[0]
#ff['bk2.13 corr'] = ff['bk2.13 gaps'].values - (scf2_13['tz_scf'].values - scf2_13['tz_scf'].values[0])
ff['bk4.1'] = df4_1['tz_ccsd']
ff['bk4.1 gaps'] = ff['bk4.1'].values - ff['bk4.1'].values[0]
ff['bk4.1 corr'] = ff['bk4.1 gaps'].values - (scf4_1['tz_scf'].values - scf4_1['tz_scf'].values[0])
ff['bk5.1'] = df5_1['tz_ccsd']
ff['bk5.1 gaps'] = ff['bk5.1'].values - ff['bk5.1'].values[0]
ff['bk5.1 corr'] = ff['bk5.1 gaps'].values - (scf5_1['tz_scf'].values - scf5_1['tz_scf'].values[0])
ff['reg1'] = dfreg1['tz_ccsd']
ff['reg1 gaps'] = ff['reg1'].values - ff['reg1'].values[0]
ff['reg1 corr'] = ff['reg1 gaps'].values - (scfreg1['tz_scf'].values - scfreg1['tz_scf'].values[0])
ff['reg2'] = dfreg2['tz_ccsd']
ff['reg2 gaps'] = ff['reg2'].values - ff['reg2'].values[0]
ff['reg2 corr'] = ff['reg2 gaps'].values - (scfreg2['tz_scf'].values - scfreg2['tz_scf'].values[0])
ff['reg3'] = dfreg3['tz_ccsd']
ff['reg3 gaps'] = ff['reg3'].values - ff['reg3'].values[0]
ff['reg3 corr'] = ff['reg3 gaps'].values - (scfreg3['tz_scf'].values - scfreg3['tz_scf'].values[0])
#ff['bk1.1'] = df1['tz_ccsd'] 
#ff['bk1.1 gaps'] = ff['bk1.1'].values - ff['bk1.1'].values[0]
#ff['bk1.2'] = df2['tz_ccsd'] 
#ff['bk1.2 gaps'] = ff['bk1.2'].values - ff['bk1.2'].values[0]
#ff['bk1.2 corr'] = ff['bk1.2 gaps'].values - (scf2['tz_scf'].values - scf2['tz_scf'].values[0])
#ff['bk1.3'] = df3['tz_ccsd']
#ff['bk1.3 gaps'] = ff['bk1.3'].values - ff['bk1.3'].values[0]
#ff['bk1.3 corr'] = ff['bk1.3 gaps'].values - (scf3['tz_scf'].values - scf3['tz_scf'].values[0])
#ff['bk1.3 gaps'] = ff['bk1.3'].values - ff['bk1.3'].values[0]
#ff['bk1.4'] = df4['tz_ccsd'] 
#ff['bk1.4 gaps'] = ff['bk1.4'].values - ff['bk1.4'].values[0]
#ff['bk1.5'] = df5['tz_ccsd']
#ff['bk1.5 gaps'] = ff['bk1.5'].values - ff['bk1.5'].values[0]
#ff['bk1.5 corr'] = ff['bk1.5 gaps'].values - (scf5['tz_scf'].values - scf5['tz_scf'].values[0])








fff = pd.DataFrame()
fff['all electron'] = ff['ae gaps'].values*toev
#fff['MDFSTU'] = ff['MDFSTU gaps'].values*toev
#fff['bk2.8'] = ff['bk2.8 gaps'].values*toev
#fff['bk2.10'] = ff['bk2.10 gaps'].values*toev
#fff['bk2.11'] = ff['bk2.11 gaps'].values*toev
#fff['bk2.12'] = ff['bk2.12 gaps'].values*toev
#fff['bk2.13'] = ff['bk2.13 gaps'].values*toev
fff['reg1'] = ff['reg1 gaps'].values*toev
#fff['reg2'] = ff['reg2 gaps'].values*toev
#fff['reg3'] = ff['reg3 gaps'].values*toev
fff['bk4.1'] = ff['bk4.1 gaps'].values*toev
fff['bk5.1'] = ff['bk5.1 gaps'].values*toev
#fff['bk1.1'] = ff['bk1.1 gaps'].values*toev
#fff['bk1.2'] = ff['bk1.2 gaps'].values*toev
#fff['bk1.3'] = ff['bk1.3 gaps'].values*toev
#fff['bk1.4'] = ff['bk1.4 gaps'].values*toev
#fff['bk1.5'] = ff['bk1.5 gaps'].values*toev

er = pd.DataFrame()
#er['MDFSTU error'] = fff['MDFSTU'].values - fff['all electron'].values
#er['bk2.8 error'] = fff['bk2.8'].values - fff['all electron'].values
#er['bk2.10 error'] = fff['bk2.10'].values - fff['all electron'].values
#er['bk2.11 error'] = fff['bk2.11'].values - fff['all electron'].values
#er['bk2.12 error'] = fff['bk2.12'].values - fff['all electron'].values
#er['bk2.13 error'] = fff['bk2.13'].values - fff['all electron'].values
er['bk4.1 error'] = fff['bk4.1'].values - fff['all electron'].values
er['bk5.1 error'] = fff['bk5.1'].values - fff['all electron'].values
er['reg1 error'] = fff['reg1'].values - fff['all electron'].values
#er['reg2 error'] = fff['reg2'].values - fff['all electron'].values
#er['reg3 error'] = fff['reg3'].values - fff['all electron'].values
#er['bk1.1 error'] = fff['bk1.1'].values - fff['all electron'].values
#er['bk1.2 error'] = fff['bk1.2'].values - fff['all electron'].values
#er['bk1.3 error'] = fff['bk1.3'].values - fff['all electron'].values
#er['bk1.4 error'] = fff['bk1.4'].values - fff['all electron'].values
#er['bk1.5 error'] = fff['bk1.5'].values - fff['all electron'].values

mads = er.mad(axis=0)


opt = pd.DataFrame()
opt['ae gaps'] = fff['all electron'].values
#opt['bk1.2 opt'] = opt['ae gaps'].values - ff['bk1.2 corr'].values*toev
#opt['bk1.3 opt'] = opt['ae gaps'].values - ff['bk1.3 corr'].values*toev
#opt['bk1.5 opt'] = opt['ae gaps'].values - ff['bk1.5 corr'].values*toev
#opt['bk2.8 opt'] = opt['ae gaps'].values - ff['bk2.8 corr'].values*toev
#opt['bk2.10 opt'] = opt['ae gaps'].values - ff['bk2.10 corr'].values*toev
#opt['bk2.11 opt'] = opt['ae gaps'].values - ff['bk2.11 corr'].values*toev
#opt['bk2.12 opt'] = opt['ae gaps'].values - ff['bk2.12 corr'].values*toev
#opt['bk2.13 opt'] = opt['ae gaps'].values - ff['bk2.13 corr'].values*toev
opt['bk4.1 opt'] = opt['ae gaps'].values - ff['bk4.1 corr'].values*toev
opt['bk5.1 opt'] = opt['ae gaps'].values - ff['bk5.1 corr'].values*toev
opt['reg1 opt'] = opt['ae gaps'].values - ff['reg1 corr'].values*toev
#opt['reg2 opt'] = opt['ae gaps'].values - ff['reg2 corr'].values*toev
#opt['reg3 opt'] = opt['ae gaps'].values - ff['reg3 corr'].values*toev


#print(mads.to_latex(index=False))


print(er.to_latex(index=False))
print(fff.to_latex(index=False))
print(opt.to_latex(index=False))
	
	



#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
