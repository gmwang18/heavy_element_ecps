#! /usr/bin/env python

import pickle 
import pandas as pd
import numpy as np

###==================================================

basis=['aug-cc-pvdz','aug-cc-pvtz','aug-cc-pvqz','aug-cc-pv5z','cc-pvdz','cc-pvtz','cc-pvqz','cc-pv5z']

###==================================================

toev = 27.211386245988
pd.options.display.float_format = '{:,.6f}'.format
workdir = '/global/homes/h/haihan/Research/HZECP/Mo/basis/Mo/validation'
scf_diff=[]
ccsd_diff=[]

for bas in basis:
        bas_old = pd.read_csv(workdir+'/old_basis/'+bas+'.table1.csv', sep='\s*,\s*', engine='python')
        bas_new = pd.read_csv(workdir+'/new_basis/'+bas+'.table1.csv', sep='\s*,\s*', engine='python')
        scf = (bas_new['SCF'][1]-bas_old['SCF'][1])*toev
        scf_diff.append(scf)

for bas in basis:
        bas_old = pd.read_csv(workdir+'/old_basis/'+bas+'.table1.csv', sep='\s*,\s*', engine='python')
        bas_new = pd.read_csv(workdir+'/new_basis/'+bas+'.table1.csv', sep='\s*,\s*', engine='python')
        ccsd = (bas_new['CCSD'][1]-bas_old['CCSD'][1])*toev
        ccsd_diff.append(ccsd)


df= pd.DataFrame({'basis': basis, 'scf_diff' : scf_diff, 'ccsd_diff': ccsd_diff})

df.to_csv("diff.csv", float_format="%.6f")
