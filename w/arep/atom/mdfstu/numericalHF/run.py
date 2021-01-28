import pandas as pd
import numpy as np
import shutil
import pickle
import os,sys

def get_en_pp():
    states=['pp1','pp2','pp3','pp4','pp5','pp6','pp7','pp8','pp9','pp10','pp11','pp12','pp13','pp14','pp15','pp16']
    #states=['pp1','pp2','pp3','pp4']
    ppenergy=[]
    os.system(r"""cp ecps/stu.d yoon-modified/pp.d""")
    for i,state in enumerate(states):
        statefile='ppinput/'+state+'.d'
        shutil.copy(statefile,'yoon-modified/ip.d')
        os.system(r"""cd yoon-modified/; ./a.out &> energy.out; grep 'TOTAL' energy.out | awk -F'-' '{printf("%.6f\n",-$2)}' > ppenergy.out; cd ..""")
        outfile=open('yoon-modified/ppenergy.out','rb')
        energy = float(outfile.readline().split()[0])
        ppenergy.append(energy)
        outfile.close()
    return ppenergy

if __name__== '__main__':
    ppenergy = get_en_pp()
    print(ppenergy)
    for i in range(0,len(ppenergy)):
        print(ppenergy[i])

    numhf = pd.DataFrame()
    numhf['SCF'] = ppenergy
    numhf.to_csv('./num.dat', sep='\t', index=False)
