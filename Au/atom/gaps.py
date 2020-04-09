#! /usr/bin/env python

import pickle 
import pandas as pd

pd.options.display.float_format = '{:,.5f}'.format

df = pd.DataFrame()

ae = pd.read_csv("AE/dkh/basis/3.csv", sep='\s*,\s*', engine='python')
df['AE'] = ae['CCSD'].values-ae['CCSD'].values[0]

pps=['UC', 'SBKJC', 'CRENBL', 'LANL2DZ', 'MDFSTU', 'rMDFSTU', 'GW-1', 'GW-2', 'GW-3']

for pp in pps:
	ecp = pd.read_csv(pp+'/basis/3.csv', sep='\s*,\s*', engine='python')
	df[pp] = ecp['CCSD'].values-ecp['CCSD'].values[0]

mad = pd.DataFrame(columns=df.columns)
diffs = 27.211386*df.copy()
diffs=diffs[1:]   # Getting rid of ground state
print(diffs)

print("MADS")
for pp in pps: 
	print(pp)
	diffs[pp] = diffs[pp] - diffs['AE']
	mad.loc['MAD',pp]=diffs[pp].abs().mean()
	print(diffs[pp].abs().mean())

print(diffs.to_latex())
print(mad.to_latex())
