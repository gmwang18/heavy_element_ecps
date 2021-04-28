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

##reg16##
dfreg16=pd.DataFrame()

for basis in ['tz']:
	reg16 = pd.read_csv('./'+basis+'.reg16.csv',skip_blank_lines=True,skipinitialspace=True)
	dfreg16[basis+'_ccsd'] = reg16['CCSD']

bkreg16 = dfreg16.filter(regex='ccsd')

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

##bk16.1##
dfbk16_1=pd.DataFrame()

for basis in ['tz']:
	bk16_1 = pd.read_csv('./'+basis+'.bk16.1.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk16_1[basis+'_ccsd'] = bk16_1['CCSD']

bkbk16_1 = dfbk16_1.filter(regex='ccsd')

##bk16.2##
dfbk16_2=pd.DataFrame()

for basis in ['tz']:
	bk16_2 = pd.read_csv('./'+basis+'.bk16.2.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk16_2[basis+'_ccsd'] = bk16_2['CCSD']

bkbk16_2 = dfbk16_2.filter(regex='ccsd')

##bk16.5##
dfbk16_5=pd.DataFrame()

for basis in ['tz']:
	bk16_5 = pd.read_csv('./'+basis+'.bk16.5.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk16_5[basis+'_ccsd'] = bk16_5['CCSD']

bkbk16_5 = dfbk16_5.filter(regex='ccsd')

##bk16.11##
dfbk16_11=pd.DataFrame()

for basis in ['tz']:
	bk16_11 = pd.read_csv('./'+basis+'.bk16.11.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk16_11[basis+'_ccsd'] = bk16_11['CCSD']

bkbk16_11 = dfbk16_11.filter(regex='ccsd')

##bk16.12##
dfbk16_12=pd.DataFrame()

for basis in ['tz']:
	bk16_12 = pd.read_csv('./'+basis+'.bk16.12.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk16_12[basis+'_ccsd'] = bk16_12['CCSD']

bkbk16_12 = dfbk16_12.filter(regex='ccsd')

##bk16.13##
dfbk16_13=pd.DataFrame()

for basis in ['tz']:
	bk16_13 = pd.read_csv('./'+basis+'.bk16.13.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk16_13[basis+'_ccsd'] = bk16_13['CCSD']

bkbk16_13 = dfbk16_13.filter(regex='ccsd')

##bk16.14##
dfbk16_14=pd.DataFrame()

for basis in ['tz']:
	bk16_14 = pd.read_csv('./'+basis+'.bk16.14.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk16_14[basis+'_ccsd'] = bk16_14['CCSD']

bkbk16_14 = dfbk16_14.filter(regex='ccsd')

##bk16.1.2##
dfbk16_1_2=pd.DataFrame()

for basis in ['tz']:
	bk16_1_2 = pd.read_csv('./'+basis+'.bk16.1.2.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk16_1_2[basis+'_ccsd'] = bk16_1_2['CCSD']

bkbk16_1_2 = dfbk16_1_2.filter(regex='ccsd')

##bk24.1##
dfbk24_1=pd.DataFrame()

for basis in ['tz']:
	bk24_1 = pd.read_csv('./'+basis+'.bk24.1.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk24_1[basis+'_ccsd'] = bk24_1['CCSD']

bkbk24_1 = dfbk24_1.filter(regex='ccsd')

##fbk1.1##
dffbk1_1=pd.DataFrame()

for basis in ['tz']:
	fbk1_1 = pd.read_csv('./'+basis+'.fbk1.1.csv',skip_blank_lines=True,skipinitialspace=True)
	dffbk1_1[basis+'_ccsd'] = fbk1_1['CCSD']

bkfbk1_1 = dffbk1_1.filter(regex='ccsd')

##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr



#states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
#hf['SCF'] = states
#corr['Correlation'] = states

scf = pd.DataFrame()

scf['all electron'] = a['SCF']
scf['ae gaps'] = scf['all electron'].values - scf['all electron'].values[0]
scf['UC'] = uc['SCF']
scf['UC gaps'] = scf['UC'].values - scf['UC'].values[0]
scf['reg16'] = reg16['SCF']
scf['reg16 gaps'] = scf['reg16'].values - scf['reg16'].values[0]
scf['MDFSTU'] = b['SCF']
scf['MDFSTU gaps'] = scf['MDFSTU'].values - scf['MDFSTU'].values[0]
scf['CRENBL'] = cren['SCF']
scf['CRENBL gaps'] = scf['CRENBL'].values - scf['CRENBL'].values[0]
scf['LANL2'] = lanl2['SCF']
scf['LANL2 gaps'] = scf['LANL2'].values - scf['LANL2'].values[0]
scf['SBKJC'] = sbkjc['SCF']
scf['SBKJC gaps'] = scf['SBKJC'].values - scf['SBKJC'].values[0]
scf['ccECP'] = ccecp['SCF']
scf['ccECP gaps'] = scf['ccECP'].values - scf['ccECP'].values[0]
scf['bk16.1'] = bk16_1['SCF']
scf['bk16.1 gaps'] = scf['bk16.1'].values - scf['bk16.1'].values[0]
scf['bk16.2'] = bk16_2['SCF']
scf['bk16.2 gaps'] = scf['bk16.2'].values - scf['bk16.2'].values[0]
scf['bk16.5'] = bk16_5['SCF']
scf['bk16.5 gaps'] = scf['bk16.5'].values - scf['bk16.5'].values[0]
scf['bk16.12'] = bk16_12['SCF']
scf['bk16.12 gaps'] = scf['bk16.12'].values - scf['bk16.12'].values[0]
scf['bk16.11'] = bk16_11['SCF']
scf['bk16.11 gaps'] = scf['bk16.11'].values - scf['bk16.11'].values[0]
scf['bk16.13'] = bk16_13['SCF']
scf['bk16.13 gaps'] = scf['bk16.13'].values - scf['bk16.13'].values[0]
scf['bk16.14'] = bk16_14['SCF']
scf['bk16.14 gaps'] = scf['bk16.14'].values - scf['bk16.14'].values[0]
scf['bk16.1.2'] = bk16_1_2['SCF']
scf['bk16.1.2 gaps'] = scf['bk16.1.2'].values - scf['bk16.1.2'].values[0]
scf['bk24.1'] = bk24_1['SCF']
scf['bk24.1 gaps'] = scf['bk24.1'].values - scf['bk24.1'].values[0]
scf['fbk1.1'] = fbk1_1['SCF']
scf['fbk1.1 gaps'] = scf['fbk1.1'].values - scf['fbk1.1'].values[0]

ccsd = pd.DataFrame()

ccsd['all electron'] = ae['tz_ccsd']
ccsd['ae gaps'] = ccsd['all electron'].values - ccsd['all electron'].values[0] 
ccsd['UC'] = dfuc['tz_ccsd']
ccsd['UC gaps'] = ccsd['UC'].values - ccsd['UC'].values[0]
ccsd['MDFSTU'] = stu['tz_ccsd']
ccsd['MDFSTU gaps'] = ccsd['MDFSTU'].values - ccsd['MDFSTU'].values[0]
ccsd['reg16'] = bkreg16['tz_ccsd']
ccsd['reg16 gaps'] = ccsd['reg16'].values - ccsd['reg16'].values[0]
ccsd['CRENBL'] = dfcren['tz_ccsd']
ccsd['CRENBL gaps'] = ccsd['CRENBL'].values - ccsd['CRENBL'].values[0]
ccsd['LANL2'] = dflanl2['tz_ccsd']
ccsd['LANL2 gaps'] = ccsd['LANL2'].values - ccsd['LANL2'].values[0]
ccsd['SBKJC'] = dfsbkjc['tz_ccsd']
ccsd['SBKJC gaps'] = ccsd['SBKJC'].values - ccsd['SBKJC'].values[0]
ccsd['ccECP'] = dfccecp['tz_ccsd']
ccsd['ccECP gaps'] = ccsd['ccECP'].values - ccsd['ccECP'].values[0]
ccsd['bk16.1'] = dfbk16_1['tz_ccsd']
ccsd['bk16.1 gaps'] = ccsd['bk16.1'].values - ccsd['bk16.1'].values[0]
ccsd['bk16.2'] = dfbk16_2['tz_ccsd']
ccsd['bk16.2 gaps'] = ccsd['bk16.2'].values - ccsd['bk16.2'].values[0]
ccsd['bk16.5'] = dfbk16_5['tz_ccsd']
ccsd['bk16.5 gaps'] = ccsd['bk16.5'].values - ccsd['bk16.5'].values[0]
ccsd['bk16.12'] = dfbk16_12['tz_ccsd']
ccsd['bk16.12 gaps'] = ccsd['bk16.12'].values - ccsd['bk16.12'].values[0]
ccsd['bk16.11'] = dfbk16_11['tz_ccsd']
ccsd['bk16.11 gaps'] = ccsd['bk16.11'].values - ccsd['bk16.11'].values[0]
ccsd['bk16.13'] = dfbk16_13['tz_ccsd']
ccsd['bk16.13 gaps'] = ccsd['bk16.13'].values - ccsd['bk16.13'].values[0]
ccsd['bk16.14'] = dfbk16_14['tz_ccsd']
ccsd['bk16.14 gaps'] = ccsd['bk16.14'].values - ccsd['bk16.14'].values[0]
ccsd['bk16.1.2'] = dfbk16_1_2['tz_ccsd']
ccsd['bk16.1.2 gaps'] = ccsd['bk16.1.2'].values - ccsd['bk16.1.2'].values[0]
ccsd['bk24.1'] = dfbk24_1['tz_ccsd']
ccsd['bk24.1 gaps'] = ccsd['bk24.1'].values - ccsd['bk24.1'].values[0]
ccsd['fbk1.1'] = dffbk1_1['tz_ccsd']
ccsd['fbk1.1 gaps'] = ccsd['fbk1.1'].values - ccsd['fbk1.1'].values[0]

corr = pd.DataFrame()

corr['AE'] = ccsd['ae gaps'].values - scf['ae gaps'].values
corr['UC'] = ccsd['UC gaps'].values - scf['UC gaps'].values
corr['MDFSTU'] = ccsd['MDFSTU gaps'].values - scf['MDFSTU gaps'].values
corr['CRENBL'] = ccsd['CRENBL gaps'].values - scf['CRENBL gaps'].values
corr['LANL2'] = ccsd['LANL2 gaps'].values - scf['LANL2 gaps'].values
corr['SBKJC'] = ccsd['SBKJC gaps'].values - scf['SBKJC gaps'].values
corr['ccECP'] = ccsd['ccECP gaps'].values - scf['ccECP gaps'].values
corr['bk16.1'] = ccsd['bk16.1 gaps'].values - scf['bk16.1 gaps'].values
corr['bk16.2'] = ccsd['bk16.2 gaps'].values - scf['bk16.2 gaps'].values
corr['bk16.5'] = ccsd['bk16.5 gaps'].values - scf['bk16.5 gaps'].values
corr['bk16.12'] = ccsd['bk16.12 gaps'].values - scf['bk16.12 gaps'].values
corr['bk16.11'] = ccsd['bk16.11 gaps'].values - scf['bk16.11 gaps'].values
corr['bk16.13'] = ccsd['bk16.13 gaps'].values - scf['bk16.13 gaps'].values
corr['bk16.14'] = ccsd['bk16.14 gaps'].values - scf['bk16.14 gaps'].values
corr['bk16.1.2'] = ccsd['bk16.1.2 gaps'].values - scf['bk16.1.2 gaps'].values
corr['bk24.1'] = ccsd['bk24.1 gaps'].values - scf['bk24.1 gaps'].values
#corr['fbk1.1'] = ccsd['fbk1.1 gaps'].values - scf['fbk1.1 gaps'].values

evccsd = pd.DataFrame()
evccsd['all electron'] = ccsd['ae gaps'].values*toev
evccsd['UC'] = ccsd['UC gaps'].values*toev
evccsd['MDFSTU'] = ccsd['MDFSTU gaps'].values*toev
evccsd['reg16'] = ccsd['reg16 gaps'].values*toev
evccsd['CRENBL'] = ccsd['CRENBL gaps'].values*toev
evccsd['LANL2'] = ccsd['LANL2 gaps'].values*toev
evccsd['SBKJC'] = ccsd['SBKJC gaps'].values*toev
evccsd['ccECP'] = ccsd['ccECP gaps'].values*toev
evccsd['bk16.1'] = ccsd['bk16.1 gaps'].values*toev
#evccsd['bk16.2'] = ccsd['bk16.2 gaps'].values*toev
evccsd['bk16.5'] = ccsd['bk16.5 gaps'].values*toev
evccsd['bk16.12'] = ccsd['bk16.12 gaps'].values*toev
evccsd['bk16.11'] = ccsd['bk16.11 gaps'].values*toev
evccsd['bk16.13'] = ccsd['bk16.13 gaps'].values*toev
evccsd['bk16.14'] = ccsd['bk16.14 gaps'].values*toev
evccsd['bk16.1.2'] = ccsd['bk16.1.2 gaps'].values*toev
evccsd['bk24.1'] = ccsd['bk24.1 gaps'].values*toev
#evccsd['fbk1.1'] = ccsd['fbk1.1 gaps'].values*toev

er = pd.DataFrame()

er['AE gaps'] = evccsd['all electron'].values
er['UC error'] = evccsd['UC'].values - evccsd['all electron'].values
er['MDFSTU error'] = evccsd['MDFSTU'].values - evccsd['all electron'].values
#er['reg16 error'] = evccsd['reg16'].values - evccsd['all electron'].values
er['CRENBL error'] = evccsd['CRENBL'].values - evccsd['all electron'].values
er['LANL2 error'] = evccsd['LANL2'].values - evccsd['all electron'].values
#er['SBKJC error'] = evccsd['SBKJC'].values - evccsd['all electron'].values
er['ccECP error'] = evccsd['ccECP'].values - evccsd['all electron'].values
#er['bk16.1 error'] = evccsd['bk16.1'].values - evccsd['all electron'].values
#er['bk16.2 error'] = evccsd['bk16.2'].values - evccsd['all electron'].values
#er['bk16.5 error'] = evccsd['bk16.5'].values - evccsd['all electron'].values
er['bk16.12 error'] = evccsd['bk16.12'].values - evccsd['all electron'].values
er['bk16.14 error'] = evccsd['bk16.14'].values - evccsd['all electron'].values
#er['bk16.11 error'] = evccsd['bk16.11'].values - evccsd['all electron'].values
#er['bk16.13 error'] = evccsd['bk16.13'].values - evccsd['all electron'].values
#er['bk16.1.2 error'] = evccsd['bk16.1.2'].values - evccsd['all electron'].values
#er['bk24.1 error'] = evccsd['bk24.1'].values - evccsd['all electron'].values
#er['fbk1.1 error'] = evccsd['fbk1.1'].values - evccsd['all electron'].values
er = er[1:11]

ae_gaps = er['AE gaps']
weight = ae_gaps.abs()

mad = er.copy().abs().mean()
er.loc['MAD'] = mad 

wmad = er.copy().abs().div(weight, axis=0).mean()*100
er.loc['wMAD'] = wmad



#mads = er.mad(axis=0)

#weight_er = pd.DataFrame()

#weight_er['UC error'] = (evccsd['UC'].values - evccsd['all electron'].values)/evccsd['all electron'].values
#weight_er['MDFSTU error'] = (evccsd['MDFSTU'].values - evccsd['all electron'].values)/evccsd['all electron'].values
##weight_er['reg16 error'] = (evccsd['reg16'].values - evccsd['all electron'].values)/evccsd['all electron'].values
#weight_er['CRENBL error'] = (evccsd['CRENBL'].values - evccsd['all electron'].values)/evccsd['all electron'].values
#weight_er['LANL2 error'] = (evccsd['LANL2'].values - evccsd['all electron'].values)/evccsd['all electron'].values
##weight_er['SBKJC error'] = (evccsd['SBKJC'].values - evccsd['all electron'].values)/evccsd['all electron'].values
#weight_er['ccECP error'] = (evccsd['ccECP'].values - evccsd['all electron'].values)/evccsd['all electron'].values
##weight_er['bk16.1 error'] = (evccsd['bk16.1'].values - evccsd['all electron'].values)/evccsd['all electron'].values
##weight_er['bk16.2 error'] = (evccsd['bk16.2'].values - evccsd['all electron'].values)/evccsd['all electron'].values
##weight_er['bk16.5 error'] = (evccsd['bk16.5'].values - evccsd['all electron'].values)/evccsd['all electron'].values
#weight_er['bk16.12 error'] = (evccsd['bk16.12'].values - evccsd['all electron'].values)/evccsd['all electron'].values
#weight_er['bk16.11 error'] = (evccsd['bk16.11'].values - evccsd['all electron'].values)/evccsd['all electron'].values
#weight_er['bk16.13 error'] = (evccsd['bk16.13'].values - evccsd['all electron'].values)/evccsd['all electron'].values
##weight_er['bk16.1.2 error'] = (evccsd['bk16.1.2'].values - evccsd['all electron'].values)/evccsd['all electron'].values
##weight_er['bk24.1 error'] = (evccsd['bk24.1'].values - evccsd['all electron'].values)/evccsd['all electron'].values
##weight_er['fbk1.1 error'] = (evccsd['fbk1.1'].values - evccsd['all electron'].values)/evccsd['all electron'].values

#weight_mads = weight_er.mad(axis=0)


opt = pd.DataFrame()

#opt['MDFSTU'] = (ccsd['ae gaps'].values - corr['MDFSTU'].values)*toev
#opt['ccECP'] = (ccsd['ae gaps'].values - corr['ccECP'].values)*toev
#opt['bk16.1'] = (ccsd['ae gaps'].values - corr['bk16.1'].values)*toev
opt['bk16.12'] = (ccsd['ae gaps'].values - corr['bk16.12'].values)*toev
#opt['bk24.1'] = (ccsd['ae gaps'].values - corr['bk24.1'].values)*toev






#print(mads.to_latex(index=False))


print(er.to_latex(index=False))
#print(mads.to_latex(index=False))
#print(weight_mads.to_latex(index=False))
print(opt.to_latex(index=False))
	
	



#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
