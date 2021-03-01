#! /usr/bin/env python3

import sys,os
import pandas as pd
from scipy.optimize import curve_fit
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt


#~~~~~~~~ Input ~~~~~~~~~~~~
pd.options.display.float_format = '{:,.5f}'.format
#~~~~~~~~~~~~~~~~~~~~~~~~~~~

df_scf = pd.DataFrame()
df_corr = pd.DataFrame()

basis_5 = pd.read_csv("basis/3.csv", sep='\s*,\s*', engine='python')
#numer = pd.read_csv("numerical/states/num.csv", sep='\s*,\s*', engine='python')
#print numer

df_scf['5Z'] = basis_5['SCF']
df_corr['5Z'] = basis_5['CCSD']-basis_5['SCF']

#df_scf['Numerical'] = numer['SCF']
#df_scf['Diffs'] = df_scf['5Z']-df_scf['Numerical']
df_scf['5Z.Gaps'] = df_scf['5Z']-df_scf['5Z'].iloc[0]
#df_scf['Num.Gaps'] = df_scf['Numerical']-df_scf['Numerical'].iloc[0]
#df_scf['Gap Diffs'] = df_scf['Num.Gaps']-df_scf['5Z.Gaps']
print(df_scf.to_latex())

df_corr['5Z.Gaps'] = df_corr['5Z'].values - df_corr['5Z'].values[0]
print(df_corr.to_latex())

