import pandas as pd
import numpy as np
import pickle
import os,sys

ecps = ['uc','crenbl','lanl2tz','mdfstu','mwbstu','ccECP']
#ecps = ['crenbl','uc']
toev = 27.211386

def gap_table():
        df = pd.DataFrame()
        with open('ae/test-Mo-dkh/gaps.p','rb') as f:
        #with open('uc/gaps.p','rb') as f:
                ae = pickle.load(f)
                df['AE'] = ae['extrapolated gaps']
        for ecp in ecps:
                with open(ecp+'/gaps.p','rb') as f:
                        pp = pickle.load(f)
                        df[ecp] = pp['extrapolated gaps']
        diffs = toev*df.copy()
        print("MADS")
        for ecp in ecps:
                diffs[ecp] = diffs[ecp] - diffs['AE']
                print(diffs[ecp].abs().mean())
        diffs.loc['MAD'] = diffs.abs().mean()
        diffs['AE'].loc['MAD'] = ''
        print(diffs.to_latex(index=False))

gap_table()

