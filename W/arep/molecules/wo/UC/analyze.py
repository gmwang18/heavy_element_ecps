import pandas as pd
import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt

#~~~~~ Molecules ~~~~~~

A_hf = []
A_cc = []
B_hf = []
B_cc = []

pd.options.display.float_format = '{:,.6}'.format

df=pd.DataFrame()
for bas in ['tz']:
	x = pd.read_csv(bas+'.csv',skip_blank_lines=True,skipinitialspace=True)
	df[bas+'_scf'] = x['SCF']
	df[bas+'_ccsd'] = x['CCSD']

	A_hf.append(x['W_SCF'].iloc[0])
	A_cc.append(x['W_CCSD'].iloc[0])
	B_hf.append(x['O_SCF'].iloc[0])
	B_cc.append(x['O_CCSD'].iloc[0])

print(A_hf)
print(A_cc)
print(B_hf)
print(B_cc)

df['r'] = x['Z']
df.set_index('r',inplace=True)

scf = df.filter(regex='scf')
cc = df.filter(regex='ccsd')

#~~~~~~~~~~~~~~~~~

bind = pd.DataFrame()
bind['r'] = scf.index.values
bind.set_index('r',inplace=True)
bind['bind'] = df['tz_ccsd'] - A_cc[0] - B_cc[0]
print(bind['bind'])
bind.plot()
plt.show()

bind['bind'] = bind['bind'].round(6)

bind.to_csv('tzbind', sep=' ')

