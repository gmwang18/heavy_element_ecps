#! /usr/bin/env python

import os
import sys
import numpy as np
import pandas as pd

N=3  # Number of exp in s and p
atom = "W"

params = np.array([
0.265585,	# Ratio for d exponents
2.428161,	# Lowest f exponent
0.625318,
2.833034,
1.631511,
2.500000,
])

def molpro_cc(params, aug, file_name):   # Generate Molpro type primitives and write to file
        f_exp=[]
        g_exp=[]
        h_exp=[]
        for i in range(0, N):
                f_exp.insert(0, params[0]*params[1]**i)
        for i in range(0, N-1):
                g_exp.insert(0, params[2]*params[3]**i)
        for i in range(0, N-2):
                h_exp.insert(0, params[4]*params[5]**i)

        if aug == True:
                f_exp.append(params[0]/2.5)
                g_exp.append(params[2]/2.5)
                h_exp.append(params[4]/2.5)
        
        f = open(file_name, 'w')

        f.write('{}, {}, '.format("f", atom))
        for i in f_exp:
                f.write('{:0.6f}, '.format(i))
        f.write('\n')

        f.write('{}, {}, '.format("g", atom))
        for i in g_exp:
                f.write('{:0.6f}, '.format(i))
        f.write('\n')

        f.write('{}, {}, '.format("h", atom))
        for i in h_exp:
                f.write('{:0.6f}, '.format(i))
        f.write('\n')


        f.close()

molpro_cc(params, False, "cc.molpro")
molpro_cc(params, True, "aug-cc.molpro")

