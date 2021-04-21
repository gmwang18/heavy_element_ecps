#! /usr/bin/env python

import sys,os
import numpy as np
import glob
import pandas as pd

toev=27.21138602
pd.options.display.float_format = '{:,.6f}'.format
os.system("rm num.dat")

N=[
"s2p3.d", 
"s2p4.d",
"s1p4.d",
"s2p2.d",
"s1p3.d",
"s2p1.d",
"s1p2.d",
"s2d1.d",
"s2f1.d",
"s2.d", 
"s1p1.d",
"s1.d",
"p1.d",
"d1.d",
"f1.d",
]
print(len(N))

for i in N:
        print(i)
        os.system("cp %s ../yoon/ip.d" % i)
        os.chdir("../yoon")
        os.system("./a.out | grep 'TOTAL ENERGY' | awk '{print $4}' >> ../states/num.dat")
        os.chdir("../states")

en=[]
with open('num.dat') as f:
        for line in f:
                en.append(list(map(float, line.split())))
os.system("rm num.dat")

en=np.array(en).flatten()
#print(en)

num=pd.DataFrame()
num['SCF']=en
num['GAPS']=num['SCF']-num['SCF'].iloc[0]
print(num)

num.to_csv('num.csv', sep=',', index=False)


