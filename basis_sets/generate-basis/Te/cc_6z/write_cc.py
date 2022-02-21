#! /usr/bin/env python

import os
import sys
import numpy as np
import pandas as pd

N=5  # Number of exp in s and p
atom = "Te"

params = np.array([
0.092254,	# Lowest s exponent
2.093115,	# Ratio for s exponents
0.061041,	# Lowest p exponent
2.263151,	# Ratio for p exponents
0.114000,	# Lowest d exponent
1.752626,	# Ratio for d exponents
0.156192,	# Lowest f exponent
1.702460,	# Ratio for f exponents
0.249689,	# Lowest g exponent
1.775989,	# Ratio for g exponents
0.394840,	# Lowest h exponent
1.948069,	# Ratio for h exponents
0.666542,	# Lowest i exponent
2.500000,	# Ratio for i exponents
])

def molpro_cc(params, aug, file_name):   # Generate Molpro type primitives and write to file
        s_exp=[]
        p_exp=[]
        d_exp=[]
        f_exp=[]
        g_exp=[]
        h_exp=[]
        i_exp=[]
        for i in range(0, N):
                s_exp.insert(0, params[0]*params[1]**i)
                p_exp.insert(0, params[2]*params[3]**i)
                d_exp.insert(0, params[4]*params[5]**i)
        for i in range(0, N-1):
                f_exp.insert(0, params[6]*params[7]**i)
        for i in range(0, N-2):
                g_exp.insert(0, params[8]*params[9]**i)
        for i in range(0, N-3):
                h_exp.insert(0, params[10]*params[11]**i)
        for i in range(0, N-4):
                i_exp.insert(0, params[12]*params[13]**i)

        if aug == True:
                s_exp.append(params[0]/2.5)
                p_exp.append(params[2]/2.5)
                d_exp.append(params[4]/2.5)
                f_exp.append(params[6]/2.5)
                g_exp.append(params[8]/2.5)
                h_exp.append(params[10]/2.5)
                i_exp.append(params[12]/2.5)
        
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

        f.write('{}, {}, '.format("h", atom))
        for i in h_exp:
                f.write('{:0.6f}, '.format(i))
        f.write('\n')

        f.write('{}, {}, '.format("i", atom))
        for i in i_exp:
                f.write('{:0.6f}, '.format(i))
        f.write('\n')

        f.close()

molpro_cc(params, False, "cc.molpro")
molpro_cc(params, True, "aug-cc.molpro")

