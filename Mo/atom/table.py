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


#def corr_fit(x,*parms):
#        return parms[0]+parms[1]/(x+3./8.)**3 + parms[2]/(x+3./8.)**5


df=pd.DataFrame()

ae = pd.read_csv('ae/test-Mo-dkh/tz.table1.csv',skip_blank_lines=True,skipinitialspace=True)
df['ae_ccsd'] = ae['CCSD']

for basis in ['uc','crenbl','lanl2tz','mdfstu','mwbstu','ECP1.0','ECP2.0','ECP2.1','ECP2.3','ECP2.4']:
        x = pd.read_csv(basis+'/tz.table1.csv',skip_blank_lines=True,skipinitialspace=True)
        df[basis+'_ccsd'] = x['CCSD']

ccsd = df.filter(regex='ccsd')



##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

gaps = pd.DataFrame()

for basis in ['ae','uc','crenbl','lanl2tz','mdfstu','mwbstu','ECP1.0','ECP2.1','ECP2.3','ECP2.4']:
        gaps[basis] = ccsd[basis+'_ccsd'].values - ccsd[basis+'_ccsd'].values[0]

errors = pd.DataFrame()

for basis in ['uc','crenbl','lanl2tz','mdfstu','mwbstu','ECP1.0','ECP2.1','ECP2.3','ECP2.4']:
        errors[basis] = gaps[basis].values - gaps['ae']


print(errors.to_latex(index=False))



