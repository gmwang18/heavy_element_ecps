#! /usr/bin/env python

import pickle 
import pandas as pd

pps = ['UC','MDFSTU','CRENBL','SBKJC','LANL2','ccECP']
pd.options.display.float_format = '{:,.4f}'.format

###==================================================
toev = 27.211386245988

df = pd.DataFrame()

ae = pd.read_csv("AE/dkh/basis/qz.table1.csv", sep='\s*,\s*', engine='python')
df['AE'] = ae['CCSD'].values-ae['CCSD'].values[0]

for pp in pps:
	ecp = pd.read_csv(pp+'/basis/qz.table1.csv', sep='\s*,\s*', engine='python')
	df[pp] = ecp['CCSD'].values-ecp['CCSD'].values[0]

### Drop some undesired states:
df = df.drop(index=[10])


diffs = df.copy()*toev
diffs = diffs[1:]  # Getting rid of ground state
ae_gaps = diffs['AE']  # Save AE values before subtracting
diffs = diffs.sub(ae_gaps, axis=0)

mad = diffs.copy().abs().mean()
diffs.loc['MAD'] = mad

weight = ae_gaps.abs()
wmad = diffs.copy().abs().div(weight, axis=0).mean()*100
diffs.loc['WMAD'] = wmad

diffs['AE'] = ae_gaps  # Revert back to AE gaps

#print(diffs)
print(diffs.to_latex())

