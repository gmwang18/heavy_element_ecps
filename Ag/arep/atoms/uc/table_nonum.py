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

for basis in ['tz','qz','5z']:
	x = pd.read_csv('./basis/'+basis+'.table1.csv',skip_blank_lines=True,skipinitialspace=True)
	df[basis+'_scf'] = x['SCF']
	df[basis+'_ccsd'] = x['CCSD']

scf = df.filter(regex='scf')
cc = df.filter(regex='ccsd')

n = [3,4,5]
x = np.linspace(3,7,100)

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

        #fig, ax = plt.subplots()
        #plt.plot(n, ycorr, 'o')
#       # plt.plot(x, scf_fit(x, *popt1), '--', lw=1, label="Fitted Function")
        #plt.plot(x, corr_fit(x, *popt2), '--', lw=1, label="Fitted Function")
        #plt.axhline(y=popt2[0], ls='dashed', lw=1, color='red', label='CBS limit        ')
        #ax.set(title='SCF extrapolation at %d' % i,
        #xlabel='Cardinal n',
        #ylabel='E(hartree)')
        #legend = ax.legend(loc='best', shadow=False)
        ##plt.savefig('extrap.png', format='png', dpi=100)
        #plt.show()




scf['extrap'] = scf_extrap
scf['extrap_gaps'] = scf['extrap'].values - scf['extrap'].values[0]
cc['extrap'] = np.array(corr_extrap)+np.array(scf_extrap)

##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

hf = pd.DataFrame()

hf['T'] = scf['tz_scf']
hf['Q'] = scf['qz_scf']
hf['5'] = scf['5z_scf']
hf['Extrap.'] = scf['extrap']
hf['Extrap.Gaps'] = scf['extrap_gaps']


corr = pd.DataFrame()
corr['T'] = cc['tz_ccsd']-scf['tz_scf']
corr['Q'] = cc['qz_ccsd']-scf['qz_scf']
corr['5'] = cc['5z_ccsd']-scf['5z_scf']
corr['Extrap.'] = corr_extrap
corr['Extrap.Gaps'] = corr['Extrap.'].values - corr['Extrap.'].values[0]
print(hf.to_latex(index=False))
print(corr.to_latex(index=False))
#corr['extrap'] = corr_extrap
	
import pickle
gaps = pd.DataFrame()
gaps['extrapolated gaps'] = hf['Extrap.Gaps'] + corr['Extrap.Gaps']
gaps.drop(gaps.index[0],inplace=True)
with open('gaps.p','wb') as f:
        pickle.dump(gaps,f)




#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
