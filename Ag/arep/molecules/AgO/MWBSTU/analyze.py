#!/usr/bin/env python

import pandas as pd
import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt

#~~~~~ Molecules ~~~~~~

A_hf = []
A_cc = []
B_hf = []
B_cc = []

df=pd.DataFrame()
for bas in ['5']:
	x = pd.read_csv(bas+'.csv', skip_blank_lines=True, skipinitialspace=True)
	df[bas+'_scf'] = x['SCF']
	df[bas+'_ccsd'] = x['CCSD']

	A_hf.append(x['A_SCF'].iloc[0])
	A_cc.append(x['A_CCSD'].iloc[0])
	B_hf.append(x['B_SCF'].iloc[0])
	B_cc.append(x['B_CCSD'].iloc[0])

print('A_SCF:', A_hf)
print('A_CC:',  A_cc)
print('B_SCF:', B_hf)
print('B_CC:',  B_cc)

df['z'] = x['Z']
df.set_index('z',inplace=True)

scf = df.filter(regex='scf')
cc = df.filter(regex='ccsd')

bind = pd.DataFrame()
bind['z'] = scf.index.values
bind.set_index('z',inplace=True)
bind['bind'] = df['5_ccsd'] - A_cc[0] - B_cc[0]
print(bind['bind'])
#bind.plot()
#plt.show()

bind.to_csv('5zbind', sep=' ')
