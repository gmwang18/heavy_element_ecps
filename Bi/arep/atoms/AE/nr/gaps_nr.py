#! /usr/bin/env python

import sys,os
import pandas as pd
from scipy.optimize import curve_fit
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

#~~~~~~~~ Input ~~~~~~~~~~~~
pd.options.display.float_format = '{:,.6f}'.format
#~~~~~~~~~~~~~~~~~~~~~~~~~~~

df_scf = pd.DataFrame()

basis = pd.read_csv("basis/3.csv", sep='\s*,\s*', engine='python')
numer = pd.read_csv("numerical/states/num.csv", sep='\s*,\s*', engine='python')

df_scf['basis'] = basis['SCF']
df_scf['basis_gaps'] = df_scf['basis']-df_scf['basis'].iloc[0]

df_scf['numerical'] = numer['SCF']
df_scf['num_gaps'] = df_scf['numerical']-df_scf['numerical'].iloc[0]

df_scf['gap_diffs'] = df_scf['num_gaps']-df_scf['basis_gaps']
print(df_scf.to_latex())
                                                                                                                                                                                       
