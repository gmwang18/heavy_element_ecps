import matplotlib
matplotlib.use('TkAgg')

import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt
import os,sys
import pandas as pd

ai = 1.0
bi = 1.0
toev = 27.211386

def scf_fit(x,*parms):
        return parms[0] + parms[1]*np.exp(-parms[2]*x)

#def corr_fit(x,*parms):
#        return parms[0]+parms[1]/(x+3./8.)**3 + parms[2]/(x+3./8.)**5
def corr_fit(x,a,b,c):
        return a+b/(x+3./8.)**3 + c/(x+3./8.)**5
        #return a+b/(x-3./8.)**3 + c/(x-3./8.)**5


df=pd.DataFrame()

for basis in ['dz', 'tz','qz','5z', '6z']:
	x = pd.read_csv(basis+'.table1.txt',skip_blank_lines=True,skipinitialspace=True)
	df[basis+'_scf'] = x['SCF']
	df[basis+'_ccsd'] = x['CCSD']

scf = df.filter(regex='scf')
cc = df.filter(regex='ccsd')

n = [2,3,4,5,6]
x = np.linspace(1.8,8,100)

scf_extrap = []
corr_extrap=[]
for i in df.index:
	y1 = scf.iloc[i, :].values
	y2 = cc.iloc[i, :].values
	ycorr = y2 - y1
	#print(ycorr)
	if y1[2]<y1[1] and y1[1]<y1[0] and abs(y1[2]-y1[1])<abs(y1[1]-y1[0]):
		initial = [2*y2[2]-y2[1], ai, bi]
		limit = ([2*y2[2]-y2[0]-0.2, 0, 0], [y1[2], 100, 100])
		popt1, pcov1 = curve_fit(scf_fit, n, y1, p0=initial, bounds=limit)
		scf_extrap.append(popt1[0])
	else:
		scf_extrap.append(min(y1[:]))
	popt2, pcov2 = curve_fit(corr_fit, n, ycorr)
	corr_extrap.append(popt2[0])

	fig, ax = plt.subplots()
	plt.plot(n, ycorr, 'o')
#	plt.plot(x, scf_fit(x, *popt1), '--', lw=1, label="Fitted Function")
	plt.plot(x, corr_fit(x, *popt2), '--', lw=1, label="Fitted Function")
	plt.axhline(y=popt2[0], ls='dashed', lw=1, color='red', label='CBS limit        ')
	ax.set(title='SCF extrapolation at %d' % i,
	xlabel='Cardinal n',
	ylabel='E(hartree)')
	legend = ax.legend(loc='best', shadow=False)
	#plt.savefig('extrap.png', format='png', dpi=100)
	plt.show()




scf['extrap'] = scf_extrap
scf['extrap_gaps'] = scf['extrap'].values - scf['extrap'].values[0]
cc['extrap'] = np.array(corr_extrap)+np.array(scf_extrap)

##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

hf = pd.DataFrame()

hf['D'] = scf['dz_scf']
hf['T'] = scf['tz_scf']
hf['Q'] = scf['qz_scf']
hf['5'] = scf['5z_scf']
hf['6'] = scf['6z_scf']
hf['Extrap.'] = scf['extrap']
hf['Extrap.Gaps'] = scf['extrap_gaps']


corr = pd.DataFrame()
corr['D'] = cc['dz_ccsd']-scf['dz_scf']
corr['T'] = cc['tz_ccsd']-scf['tz_scf']
corr['Q'] = cc['qz_ccsd']-scf['qz_scf']
corr['5'] = cc['5z_ccsd']-scf['5z_scf']
corr['6'] = cc['6z_ccsd']-scf['6z_scf']
corr['Extrap.'] = corr_extrap
corr['Extrap.Gaps'] = corr['Extrap.'].values - corr['Extrap.'].values[0]
print(hf.to_latex(index=False))
print(corr.to_latex(index=False))
#corr['extrap'] = corr_extrap
	
