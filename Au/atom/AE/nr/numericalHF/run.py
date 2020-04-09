import pandas as pd
import numpy as np
import shutil
import pickle
import os,sys

def get_en_ae():
    states=['ae1','ae2','ae3','ae4','ae5','ae6','ae7','ae8','ae9','ae10','ae11','ae12','ae13','ae14']
    #states=['ae1','ae2','ae3','ae4']
    aeenergy=[]
    for i,state in enumerate(states):
        statefile='aeinput/'+state+'.d'
        shutil.copy(statefile,'yoon/ip.d')
        os.system(r"""cd yoon/; ./a.out &> energy.out; grep 'TOTAL' energy.out | awk -F'-' '{printf("%.6f\n",-$2)}' > aeenergy.out; cd ..""")
        outfile=open('yoon/aeenergy.out','rb')
        energy = float(outfile.readline().split()[0])
        aeenergy.append(energy)
        outfile.close()
    return aeenergy

if __name__== '__main__':
    aeenergy = get_en_ae()
    print(aeenergy)
    for i in range(0,len(aeenergy)):
        print(aeenergy[i])

    numhf = pd.DataFrame()
    numhf['SCF'] = aeenergy
    numhf.to_csv('./num.dat', sep='\t', index=False)
