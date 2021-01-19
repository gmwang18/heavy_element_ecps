#! /usr/bin/env python3

import sys,os
import numpy as np
import glob
import pandas as pd

toev=27.21138602
pd.options.display.float_format = '{:,.6f}'.format
os.system("rm num.dat")

N=[

"st_s1d10",  
#"st_s2d10",
"st_p1d10",  
"st_s2d9",
"st_d10",  
"st_s1d9",
"st_d9",     
"st_d8",  
"st_d7",  
"st_d6",  
"st_d5",  
"st_d0",   
"st_p3",     
"st_s2",     
"st_d5f1",

]

for idx,val in enumerate(N):
    print(idx,val)
    os.system("cp %s ../yoon/ip.d" % val)
    os.chdir("../yoon")
    os.system("./a.out | grep 'TOTAL ENERGY' | awk '{print $4}' >> ../states/num.dat")
    os.chdir("../states")

raw = pd.read_csv('num.dat', header=None)
print(raw)

num=pd.DataFrame()
num['SCF']=raw.iloc[:,0]
num['GAPS']=num['SCF']-num['SCF'].iloc[0]
print(num)

num.to_csv('num.csv', sep=',', index=False)


