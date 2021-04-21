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

for basis in ['3']:
	x = pd.read_csv('./basis/'+basis+'.csv',skip_blank_lines=True,skipinitialspace=True)
	df[basis+'_scf'] = x['SCF']
	df[basis+'_ccsd'] = x['CCSD']

scf = df.filter(regex='scf')
ccsd = df.filter(regex='ccsd')



##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

hf = pd.DataFrame()

hf['Tz'] = scf['3_scf']
hf['bas. Gaps'] = hf['Tz'].values - hf['Tz'].values[0]

corr = pd.DataFrame()

corr['Tz'] = ccsd['3_ccsd'] - scf['3_scf']
corr['bas. Gaps'] = corr['Tz'].values - corr['Tz'].values[0]


print(hf.to_latex(index=False))
print(corr.to_latex(index=False))


import pickle
gaps = pd.DataFrame()
gaps['extrapolated gaps'] = hf['bas. Gaps'] + corr['bas. Gaps']
gaps.drop(gaps.index[0],inplace=True)
with open('gaps.p','wb') as f:
        pickle.dump(gaps,f)



