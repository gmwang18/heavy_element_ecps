#! /usr/bin/env python

import os
import sys
import numpy as np
import pandas as pd

N=3  # Number of exp in s and p
atom = "Bi"

params = np.array([
0.094992,	# Lowest s exponent
1.830303,	# Ratio for s exponents
0.064412,	# Lowest p exponent
2.556554,	# Ratio for p exponents
0.133505,	# Lowest d exponent
2.315892,	# Ratio for d exponents
0.198196,	# Lowest f exponent
2.352891,	# Ratio for f exponents
0.410740,	# Lowest g exponent
2.500000,	# Ratio for g exponents
])

def molpro_cc(params, aug, file_name):   # Generate Molpro type primitives and write to file
        s_exp=[]
        p_exp=[]
        d_exp=[]
        f_exp=[]
        g_exp=[]
        for i in range(0, N):
                s_exp.insert(0, params[0]*params[1]**i)
                p_exp.insert(0, params[2]*params[3]**i)
                d_exp.insert(0, params[4]*params[5]**i)
        for i in range(0, N-1):
                f_exp.insert(0, params[6]*params[7]**i)
        for i in range(0, N-2):
                g_exp.insert(0, params[8]*params[9]**i)

        if aug == True:
                s_exp.append(params[0]/2.5)
                p_exp.append(params[2]/2.5)
                d_exp.append(params[4]/2.5)
                f_exp.append(params[6]/2.5)
                g_exp.append(params[8]/2.5)
        
        f = open(file_name, 'w')

        f.write('{}, {}, '.format("s", atom))
        for i in s_exp:
                f.write('{:0.6f}, '.format(i))
        f.write('\n')

        f.write('{}, {}, '.format("p", atom))
        for i in p_exp:
                f.write('{:0.6f}, '.format(i))
        f.write('\n')

        f.write('{}, {}, '.format("d", atom))
        for i in d_exp:
                f.write('{:0.6f}, '.format(i))
        f.write('\n')

        f.write('{}, {}, '.format("f", atom))
        for i in f_exp:
                f.write('{:0.6f}, '.format(i))
        f.write('\n')

        f.write('{}, {}, '.format("g", atom))
        for i in g_exp:
                f.write('{:0.6f}, '.format(i))
        f.write('\n')

        f.close()

molpro_cc(params, False, "cc.molpro")
molpro_cc(params, True, "aug-cc.molpro")

