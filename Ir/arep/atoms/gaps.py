#! /usr/bin/env python

import pickle 
import pandas as pd
import numpy as np

###==================================================

pps=['UC','CRENBL','SBKJC','MWBSTU','MDFSTU', 'LANL2', 'ccECP']
remove_index = [17]
lmad_index = [5,3,6]

###==================================================

toev = 27.211386245988
pd.options.display.float_format = '{:,.4f}'.format

df = pd.DataFrame()
scf = pd.DataFrame()
corr = pd.DataFrame()
opts = pd.DataFrame()

ae = pd.read_csv("AE/dkh/3.csv", sep='\s*,\s*', engine='python')
df['AE'] = ae['CCSD'].values-ae['CCSD'].values[0]

for pp in pps:
	ecp = pd.read_csv(pp+'/3.csv', sep='\s*,\s*', engine='python')
	df[pp] = ecp['CCSD'].values-ecp['CCSD'].values[0]
	scf[pp] = ecp['SCF'].values-ecp['SCF'].values[0]
	corr[pp] = df[pp] - scf[pp]

### Drop some undesired states:
df = df.drop(index=remove_index)

diffs = df.copy()*toev
#for pp in pps:
#	opts[pp] = diffs['AE'] - corr[pp].values*toev

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
#print(opts.to_latex())

### Write MADs for later analysis
spectral = final_sorted.loc["MAD":"WMAD"]
#spectral = spectral.rename(columns={"CRENBS":"CRENBL"}) # Specific to Bi only
spectral = spectral.T
spectral = spectral[1:] # Getting rid of AE
#print(spectral)
spectral.to_csv("Ir.csv", float_format="%.4f")

