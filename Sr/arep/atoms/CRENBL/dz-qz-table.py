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

def scf_fit(x,*parms):
        return parms[0] + parms[1]*np.exp(-parms[2]*x)

#def corr_fit(x,*parms):
#        return parms[0]+parms[1]/(x+3./8.)**3 + parms[2]/(x+3./8.)**5
def corr_fit(x,a,b,c):
        return a+b/(x+3./8.)**3 + c/(x+3./8.)**5


df=pd.DataFrame()

for basis in ['dz','tz','qz']:
	x = pd.read_csv('./basis/'+basis+'.table1.csv',skip_blank_lines=True,skipinitialspace=True)
	df[basis+'_scf'] = x['SCF']

scf = df.filter(regex='scf')

n = [2,3,4]

scf_extrap = []
corr_extrap=[]
for i in df.index:
	y1 = scf.iloc[i, :].values
	#print(ycorr)
	initial = [2*y1[2]-y1[1], ai, bi]
	limit = ([2*(y1[2]-y1[0])+y1[2], 0, 0], [y1[2], 100, 100])
	popt1, pcov1 = curve_fit(scf_fit, n, y1, p0=initial, bounds=limit)
	scf_extrap.append(popt1[0])

        #if i == 6:
        #fig, ax = plt.subplots()
        #plt.plot(n, y1, 'o')
        #plt.plot(x, scf_fit(x, *popt1), '--', lw=1, label="Fitted Function")
        #plt.axhline(y=popt1[0], ls='dashed', lw=1, color='red', label='CBS limit    ')
        #ax.set(title='SCF extrapolation at %d' % i,
        #xlabel='Cardinal n',
        #ylabel='E(hartree)')
        #legend = ax.legend(loc='best', shadow=False)
        ##plt.savefig('extrap.png', format='png', dpi=100)
        #plt.show()



scf['extrap'] = scf_extrap
scf['extrap_gaps'] = scf['extrap'].values - scf['extrap'].values[0]

##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

hf = pd.DataFrame()


#states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
#hf['SCF'] = states
#corr['Correlation'] = states



hf['D'] = scf['dz_scf']
hf['T'] = scf['tz_scf']
hf['Q'] = scf['qz_scf']
hf['Extrap.'] = scf['extrap']
x = pd.read_csv('./numericalHF/num.dat',skip_blank_lines=True)
hf['Numerical'] = x['SCF']
hf['Diffs'] = hf['Extrap.'] - hf['Numerical']
hf['Extrap.Gaps'] = scf['extrap_gaps']
hf['Num. Gaps'] = hf['Numerical'].values - hf['Numerical'].values[0]
hf['Gap Diffs'] = (hf['Extrap.Gaps'] - hf['Num. Gaps'])*toev


print(hf.to_latex(index=False))


#corr['extrap'] = corr_extrap
	
	



#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
