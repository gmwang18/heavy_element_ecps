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
	mdfstu = pd.read_csv('./'+basis+'.mdfstu.csv',skip_blank_lines=True,skipinitialspace=True)
	dfstu[basis+'_ccsd'] = mdfstu['CCSD']

stu = dfstu.filter(regex='ccsd')

##UC##
dfUC=pd.DataFrame()

for basis in ['tz']:
	UC = pd.read_csv('./'+basis+'.UC.csv',skip_blank_lines=True,skipinitialspace=True)
	dfUC[basis+'_ccsd'] = UC['CCSD']

fin_UC = dfUC.filter(regex='ccsd')

##reg-mdfstu##
dfreg=pd.DataFrame()

for basis in ['tz']:
	reg = pd.read_csv('./'+basis+'.reg.csv',skip_blank_lines=True,skipinitialspace=True)
	dfreg[basis+'_ccsd'] = reg['CCSD']

bkreg = dfreg.filter(regex='ccsd')


##LANL2##
dflanl2=pd.DataFrame()

for basis in ['tz']:
	lanl2 = pd.read_csv('./'+basis+'.LANL2.csv',skip_blank_lines=True,skipinitialspace=True)
	dflanl2[basis+'_ccsd'] = lanl2['CCSD']

fin_lanl2 = dflanl2.filter(regex='ccsd')


##CRENBL##
dfcrenbl=pd.DataFrame()

for basis in ['tz']:
	crenbl = pd.read_csv('./'+basis+'.CRENBL.csv',skip_blank_lines=True,skipinitialspace=True)
	dfcrenbl[basis+'_ccsd'] = crenbl['CCSD']

fin_crenbl = dfcrenbl.filter(regex='ccsd')


##SBKJC##
dfsbkjc=pd.DataFrame()

for basis in ['tz']:
	sbkjc = pd.read_csv('./'+basis+'.SBKJC.csv',skip_blank_lines=True,skipinitialspace=True)
	dfsbkjc[basis+'_ccsd'] = sbkjc['CCSD']

fin_sbkjc = dfsbkjc.filter(regex='ccsd')


##bk1.3##
dfbk1_3=pd.DataFrame()

for basis in ['tz']:
	bk1_3 = pd.read_csv('./'+basis+'.bk1.3.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk1_3[basis+'_ccsd'] = bk1_3['CCSD']

fin_bk1_3 = dfbk1_3.filter(regex='ccsd')


##bk1.4##
dfbk1_4=pd.DataFrame()

for basis in ['tz']:
	bk1_4 = pd.read_csv('./'+basis+'.bk1.4.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk1_4[basis+'_ccsd'] = bk1_4['CCSD']

fin_bk1_4 = dfbk1_4.filter(regex='ccsd')


##bk1.5##
dfbk1_5=pd.DataFrame()

for basis in ['tz']:
	bk1_5 = pd.read_csv('./'+basis+'.bk1.5.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk1_5[basis+'_ccsd'] = bk1_5['CCSD']

fin_bk1_5 = dfbk1_5.filter(regex='ccsd')


##bk1.6##
dfbk1_6=pd.DataFrame()

for basis in ['tz']:
	bk1_6 = pd.read_csv('./'+basis+'.bk1.6.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk1_6[basis+'_ccsd'] = bk1_6['CCSD']

fin_bk1_6 = dfbk1_6.filter(regex='ccsd')


##bk1.7##
dfbk1_7=pd.DataFrame()

for basis in ['tz']:
	bk1_7 = pd.read_csv('./'+basis+'.bk1.7.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk1_7[basis+'_ccsd'] = bk1_7['CCSD']

fin_bk1_7 = dfbk1_7.filter(regex='ccsd')

##bk1.8##
dfbk1_8=pd.DataFrame()

for basis in ['tz']:
	bk1_8 = pd.read_csv('./'+basis+'.bk1.8.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk1_8[basis+'_ccsd'] = bk1_8['CCSD']

fin_bk1_8 = dfbk1_8.filter(regex='ccsd')

##bk1.9##
dfbk1_9=pd.DataFrame()

for basis in ['tz']:
	bk1_9 = pd.read_csv('./'+basis+'.bk1.9.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk1_9[basis+'_ccsd'] = bk1_9['CCSD']

fin_bk1_9 = dfbk1_9.filter(regex='ccsd')

##bk2.3##
dfbk2_3=pd.DataFrame()

for basis in ['tz']:
	bk2_3 = pd.read_csv('./'+basis+'.bk2.3.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk2_3[basis+'_ccsd'] = bk2_3['CCSD']

fin_bk2_3 = dfbk2_3.filter(regex='ccsd')


##bk2.4##
dfbk2_4=pd.DataFrame()

for basis in ['tz']:
	bk2_4 = pd.read_csv('./'+basis+'.bk2.4.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk2_4[basis+'_ccsd'] = bk2_4['CCSD']

fin_bk2_4 = dfbk2_4.filter(regex='ccsd')

##bk2.6##
dfbk2_6=pd.DataFrame()

for basis in ['tz']:
	bk2_6 = pd.read_csv('./'+basis+'.bk2.6.csv',skip_blank_lines=True,skipinitialspace=True)
	dfbk2_6[basis+'_ccsd'] = bk2_6['CCSD']

fin_bk2_6 = dfbk2_6.filter(regex='ccsd')



##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

ccsd = pd.DataFrame()


#states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
#hf['SCF'] = states
#corr['Correlation'] = states



ccsd['all electron'] = ae['tz_ccsd']
ccsd['ae gaps'] = ccsd['all electron'].values - ccsd['all electron'].values[0] 
ccsd['UC'] = fin_UC['tz_ccsd']
ccsd['UC gaps'] = ccsd['UC'].values - ccsd['UC'].values[0]
ccsd['MDFSTU'] = stu['tz_ccsd']
ccsd['MDFSTU gaps'] = ccsd['MDFSTU'].values - ccsd['MDFSTU'].values[0]
ccsd['reg-MDFSTU'] = dfreg['tz_ccsd']
ccsd['reg-MDFSTU gaps'] = ccsd['reg-MDFSTU'].values - ccsd['reg-MDFSTU'].values[0]
ccsd['LANL2'] = dflanl2['tz_ccsd']
ccsd['LANL2 gaps'] = ccsd['LANL2'].values - ccsd['LANL2'].values[0]
ccsd['CRENBL'] = dfcrenbl['tz_ccsd']
ccsd['CRENBL gaps'] = ccsd['CRENBL'].values - ccsd['CRENBL'].values[0]
ccsd['SBKJC'] = dfsbkjc['tz_ccsd']
ccsd['SBKJC gaps'] = ccsd['SBKJC'].values - ccsd['SBKJC'].values[0]
ccsd['bk1.3'] = dfbk1_3['tz_ccsd']
ccsd['bk1.3 gaps'] = ccsd['bk1.3'].values - ccsd['bk1.3'].values[0]
ccsd['bk1.4'] = dfbk1_4['tz_ccsd']
ccsd['bk1.4 gaps'] = ccsd['bk1.4'].values - ccsd['bk1.4'].values[0]
ccsd['bk1.5'] = dfbk1_5['tz_ccsd']
ccsd['bk1.5 gaps'] = ccsd['bk1.5'].values - ccsd['bk1.5'].values[0]
ccsd['bk1.6'] = dfbk1_6['tz_ccsd']
ccsd['bk1.6 gaps'] = ccsd['bk1.6'].values - ccsd['bk1.6'].values[0]
ccsd['bk1.7'] = dfbk1_7['tz_ccsd']
ccsd['bk1.7 gaps'] = ccsd['bk1.7'].values - ccsd['bk1.7'].values[0]
ccsd['bk1.8'] = dfbk1_8['tz_ccsd']
ccsd['bk1.8 gaps'] = ccsd['bk1.8'].values - ccsd['bk1.8'].values[0]
ccsd['bk1.9'] = dfbk1_9['tz_ccsd']
ccsd['bk1.9 gaps'] = ccsd['bk1.9'].values - ccsd['bk1.9'].values[0]
ccsd['bk2.3'] = dfbk2_3['tz_ccsd']
ccsd['bk2.3 gaps'] = ccsd['bk2.3'].values - ccsd['bk2.3'].values[0]
ccsd['bk2.4'] = dfbk2_4['tz_ccsd']
ccsd['bk2.4 gaps'] = ccsd['bk2.4'].values - ccsd['bk2.4'].values[0]
ccsd['bk2.6'] = dfbk2_6['tz_ccsd']
ccsd['bk2.6 gaps'] = ccsd['bk2.6'].values - ccsd['bk2.6'].values[0]


scf = pd.DataFrame()


scf['reg-MDFSTU'] = mdfstu['SCF']

scf_gaps = pd.DataFrame()

scf_gaps['UC'] = (UC['SCF'].values - UC['SCF'].values[0])*toev
scf_gaps['reg-MDFSTU'] = (mdfstu['SCF'].values - mdfstu['SCF'].values[0])*toev
scf_gaps['LANL2'] = (lanl2['SCF'].values - lanl2['SCF'].values[0])*toev
scf_gaps['SBKJC'] = (sbkjc['SCF'].values - sbkjc['SCF'].values[0])*toev
scf_gaps['CRENBL'] = (crenbl['SCF'].values - crenbl['SCF'].values[0])*toev
scf_gaps['bk1.3'] = (bk1_3['SCF'].values - bk1_3['SCF'].values[0])*toev
scf_gaps['bk1.4'] = (bk1_4['SCF'].values - bk1_4['SCF'].values[0])*toev
scf_gaps['bk1.5'] = (bk1_5['SCF'].values - bk1_5['SCF'].values[0])*toev
scf_gaps['bk1.6'] = (bk1_6['SCF'].values - bk1_6['SCF'].values[0])*toev
scf_gaps['bk1.7'] = (bk1_7['SCF'].values - bk1_7['SCF'].values[0])*toev
scf_gaps['bk1.8'] = (bk1_8['SCF'].values - bk1_8['SCF'].values[0])*toev
scf_gaps['bk1.9'] = (bk1_9['SCF'].values - bk1_9['SCF'].values[0])*toev
scf_gaps['bk2.3'] = (bk2_3['SCF'].values - bk2_3['SCF'].values[0])*toev
scf_gaps['bk2.4'] = (bk2_4['SCF'].values - bk2_4['SCF'].values[0])*toev
scf_gaps['bk2.6'] = (bk2_6['SCF'].values - bk2_6['SCF'].values[0])*toev


ccsd_gaps = pd.DataFrame()
ccsd_gaps['all electron'] = ccsd['ae gaps'].values*toev
ccsd_gaps['UC'] = ccsd['UC gaps'].values*toev
ccsd_gaps['MDFSTU'] = ccsd['MDFSTU gaps'].values*toev
ccsd_gaps['reg-MDFSTU'] = ccsd['reg-MDFSTU gaps'].values*toev
ccsd_gaps['LANL2'] = ccsd['LANL2 gaps'].values*toev
ccsd_gaps['CRENBL'] = ccsd['CRENBL gaps'].values*toev
ccsd_gaps['SBKJC'] = ccsd['SBKJC gaps'].values*toev
ccsd_gaps['bk1.3'] = ccsd['bk1.3 gaps'].values*toev
ccsd_gaps['bk1.4'] = ccsd['bk1.4 gaps'].values*toev
ccsd_gaps['bk1.5'] = ccsd['bk1.5 gaps'].values*toev
ccsd_gaps['bk1.6'] = ccsd['bk1.6 gaps'].values*toev
ccsd_gaps['bk1.7'] = ccsd['bk1.7 gaps'].values*toev
ccsd_gaps['bk1.8'] = ccsd['bk1.8 gaps'].values*toev
ccsd_gaps['bk1.9'] = ccsd['bk1.9 gaps'].values*toev
ccsd_gaps['bk2.3'] = ccsd['bk2.3 gaps'].values*toev
ccsd_gaps['bk2.4'] = ccsd['bk2.4 gaps'].values*toev
ccsd_gaps['bk2.6'] = ccsd['bk2.6 gaps'].values*toev

corr = pd.DataFrame()
corr['UC'] = ccsd_gaps['UC'].values - scf_gaps['UC'].values
corr['reg-MDFSTU'] = ccsd_gaps['reg-MDFSTU'].values - scf_gaps['reg-MDFSTU'].values
corr['LANL2'] = ccsd_gaps['LANL2'].values - scf_gaps['LANL2'].values
corr['CRENBL'] = ccsd_gaps['CRENBL'].values - scf_gaps['CRENBL'].values
corr['SBKJC'] = ccsd_gaps['SBKJC'].values - scf_gaps['SBKJC'].values
corr['bk1.3'] = ccsd_gaps['bk1.3'].values - scf_gaps['bk1.3'].values
corr['bk1.4'] = ccsd_gaps['bk1.4'].values - scf_gaps['bk1.4'].values
corr['bk1.5'] = ccsd_gaps['bk1.5'].values - scf_gaps['bk1.5'].values
corr['bk1.6'] = ccsd_gaps['bk1.6'].values - scf_gaps['bk1.6'].values
corr['bk1.7'] = ccsd_gaps['bk1.7'].values - scf_gaps['bk1.7'].values
corr['bk1.8'] = ccsd_gaps['bk1.8'].values - scf_gaps['bk1.8'].values
corr['bk1.9'] = ccsd_gaps['bk1.9'].values - scf_gaps['bk1.9'].values
corr['bk2.3'] = ccsd_gaps['bk2.3'].values - scf_gaps['bk2.3'].values
corr['bk2.4'] = ccsd_gaps['bk2.4'].values - scf_gaps['bk2.4'].values
corr['bk2.6'] = ccsd_gaps['bk2.6'].values - scf_gaps['bk2.6'].values



er = pd.DataFrame()
er['AE gaps'] = ccsd_gaps['all electron']
er['UC'] = ccsd_gaps['UC'].values -ccsd_gaps['all electron'].values
er['CRENBL'] = ccsd_gaps['CRENBL'].values - ccsd_gaps['all electron'].values
er['LANL2'] = ccsd_gaps['LANL2'].values - ccsd_gaps['all electron'].values
er['SBKJC'] = ccsd_gaps['SBKJC'].values - ccsd_gaps['all electron'].values
er['MDFSTU'] = ccsd_gaps['MDFSTU'].values -ccsd_gaps['all electron'].values
#er['reg-MDFSTU error'] = ccsd_gaps['reg-MDFSTU'].values - ccsd_gaps['all electron'].values
#er['bk1.3 error'] = ccsd_gaps['bk1.3'].values - ccsd_gaps['all electron'].values
#er['bk1.4 error'] = ccsd_gaps['bk1.4'].values - ccsd_gaps['all electron'].values
#er['bk1.5 error'] = ccsd_gaps['bk1.5'].values - ccsd_gaps['all electron'].values
#er['bk1.6 error'] = ccsd_gaps['bk1.6'].values - ccsd_gaps['all electron'].values
#er['bk1.7 error'] = ccsd_gaps['bk1.7'].values - ccsd_gaps['all electron'].values
#er['ccECP error'] = ccsd_gaps['bk1.8'].values - ccsd_gaps['all electron'].values
#er['bk1.9 error'] = ccsd_gaps['bk1.9'].values - ccsd_gaps['all electron'].values
#er['bk2.3 error'] = ccsd_gaps['bk2.3'].values - ccsd_gaps['all electron'].values
#er['bk2.4 error'] = ccsd_gaps['bk2.4'].values - ccsd_gaps['all electron'].values
er['ccECP-AREP'] = ccsd_gaps['bk2.6'].values - ccsd_gaps['all electron'].values

mads = er.mad(axis=0)

weight_er = pd.DataFrame()

weight_er['UC error'] = (ccsd_gaps['UC'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
weight_er['CRENBL error'] = (ccsd_gaps['CRENBL'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
weight_er['LANL2 error'] = (ccsd_gaps['LANL2'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
weight_er['SBKJC error'] = (ccsd_gaps['SBKJC'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
weight_er['MDFSTU error'] = (ccsd_gaps['MDFSTU'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
#weight_er['reg-MDFSTU error'] = (ccsd_gaps['reg-MDFSTU'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
#weight_er['bk1.3 error'] = (ccsd_gaps['bk1.3'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
#weight_er['bk1.4 error'] = (ccsd_gaps['bk1.4'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
#weight_er['bk1.5 error'] = (ccsd_gaps['bk1.5'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
#weight_er['bk1.6 error'] = (ccsd_gaps['bk1.6'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
#weight_er['bk1.7 error'] = (ccsd_gaps['bk1.7'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
#weight_er['ccECP error'] = (ccsd_gaps['bk1.8'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
#weight_er['bk1.9 error'] = (ccsd_gaps['bk1.9'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
#weight_er['bk2.3 error'] = (ccsd_gaps['bk2.3'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
#weight_er['bk2.4 error'] = (ccsd_gaps['bk2.4'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values
weight_er['ccECP error'] = (ccsd_gaps['bk2.6'].values - ccsd_gaps['all electron'].values)/ccsd_gaps['all electron'].values

weight_mads = weight_er.mad(axis=0)


opt = pd.DataFrame()

opt['reg-MDFSTU'] = ccsd_gaps['all electron'].values - corr['reg-MDFSTU'].values
opt['LANL2'] = ccsd_gaps['all electron'].values - corr['LANL2'].values
#opt['bk1.3'] = ccsd_gaps['all electron'].values - corr['bk1.3'].values
#opt['bk1.4'] = ccsd_gaps['all electron'].values - corr['bk1.4'].values
#opt['bk1.5'] = ccsd_gaps['all electron'].values - corr['bk1.5'].values
#opt['bk1.6'] = ccsd_gaps['all electron'].values - corr['bk1.6'].values
#opt['bk1.7'] = ccsd_gaps['all electron'].values - corr['bk1.7'].values
#opt['bk1.8'] = ccsd_gaps['all electron'].values - corr['bk1.8'].values
#opt['bk1.9'] = ccsd_gaps['all electron'].values - corr['bk1.9'].values
opt['bk2.3'] = ccsd_gaps['all electron'].values - corr['bk2.3'].values
opt['bk2.4'] = ccsd_gaps['all electron'].values - corr['bk2.4'].values
opt['bk2.6'] = ccsd_gaps['all electron'].values - corr['bk2.6'].values






#print(mads.to_latex(index=False))


print(er.to_latex(index=False))
print(mads.to_latex(index=False))

print(weight_mads.to_latex(index=False))
#print(opt.to_latex(index=False))
	



#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
