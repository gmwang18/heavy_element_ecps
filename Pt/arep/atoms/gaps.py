#! /usr/bin/env python

import pickle 
import pandas as pd
import numpy as np

###==================================================

pps=['UC','MDFSTU','CRENBL','SBKJC','LANL2','MWBSTU','bk2.0','bk3.2','bk2.4']
remove_index = [12,13,14]
lmad_index = [1,5,7]

###==================================================

toev = 27.211386245988
pd.options.display.float_format = '{:,.4f}'.format

df = pd.DataFrame()

ae = pd.read_csv("AE/dkh/basis/3.csv", sep='\s*,\s*', engine='python')
df['AE'] = ae['CCSD'].values-ae['CCSD'].values[0]

for pp in pps:
	ecp = pd.read_csv(pp+'/basis/3.table1.csv', sep='\s*,\s*', engine='python')
	df[pp] = ecp['CCSD'].values-ecp['CCSD'].values[0]

### Drop some undesired states:
df = df.drop(index=remove_index)

diffs = df.copy()*toev
diffs = diffs[1:]  # Getting rid of ground state
ae_gaps = diffs['AE']  # Save AE values before subtracting
diffs = diffs.sub(ae_gaps, axis=0)

mad = diffs.copy().abs().mean()
diffs.loc['MAD'] = mad

lmad = diffs.copy().loc[lmad_index].abs().mean()
diffs.loc['LMAD'] = lmad

weight = np.sqrt(ae_gaps.abs())
wmad = diffs.copy().abs().div(weight, axis=0).mean()*100
diffs.loc['WMAD'] = wmad

diffs['AE'] = ae_gaps  # Revert back to AE gaps

### Sorting everything except AE
ecp_sorted = diffs.iloc[:,1:].sort_values(by="WMAD", ascending=False, axis=1)
final_sorted = pd.concat([diffs.iloc[:,0:1], ecp_sorted], axis=1)
#print(final_sorted)
print(final_sorted.to_latex())

### Write MADs for later analysis
spectral = final_sorted.loc["MAD":"WMAD"]
#spectral = spectral.rename(columns={"CRENBS":"CRENBL"}) # Specific to Bi only
spectral = spectral.T
spectral = spectral[1:] # Getting rid of AE
#print(spectral)
spectral.to_csv("Pt.csv", float_format="%.4f")

