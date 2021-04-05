import numpy as np

import matplotlib as mpl
import pickle
mpl.use('TkAgg')
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt
import os,sys
import pandas as pd

ai = 1.0
bi = 1.0
toev = 27.211386

#def scf_fit(x,*parms):
#        return parms[0] + parms[1]*np.exp(-parms[2]*x)

#def corr_fit(x,*parms):
#        return parms[0]+parms[1]/(x+3./8.)**3 + parms[2]/(x+3./8.)**5
#def corr_fit(x,a,b,c):
#        return a+b/(x+3./8.)**3 + c/(x+3./8.)**5

##all electron##
dfae=pd.DataFrame()

for basis in ['tz']:
        a1 = pd.read_csv('./'+basis+'.ae.csv',skip_blank_lines=True,skipinitialspace=True)
        a2 = pd.read_csv('./'+basis+'.ae.csv',skip_blank_lines=True,skipinitialspace=True)
        dfae[basis+'_z'] = a1['z']
        dfae[basis+'_BE'] = a1['BE']


aez = dfae.filter(regex='z')
aebe = dfae.filter(regex='BE')

##Stuttgart##
dfstu=pd.DataFrame()

for basis in ['tz']:
        b = pd.read_csv('./'+basis+'.mdfstu.csv',skip_blank_lines=True,skipinitialspace=True)
        dfstu[basis+'_z'] = b['Z']
        dfstu[basis+'_ccsd'] = b['CCSD']

stuccsd = dfstu.filter(regex='ccsd')

##bk8.4.1##
dfbk8_4_1=pd.DataFrame()

for basis in ['tz']:
        c4 = pd.read_csv('./'+basis+'.bk8.4.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk8_4_1[basis+'_z'] = c4['Z']
        dfbk8_4_1[basis+'_ccsd'] = c4['CCSD']

bk4ccsd = dfbk8_4_1.filter(regex='ccsd')

##bk9.5.1##
dfbk9_5_1=pd.DataFrame()

for basis in ['tz']:
        c5 = pd.read_csv('./'+basis+'.bk9.5.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk9_5_1[basis+'_z'] = c5['Z']
        dfbk9_5_1[basis+'_ccsd'] = c5['CCSD']

bk5ccsd = dfbk9_5_1.filter(regex='ccsd')

##bkc1.1##
dfbkc1_1=pd.DataFrame()

for basis in ['tz']:
        bkc1_1 = pd.read_csv('./'+basis+'.bkc1.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbkc1_1[basis+'_z'] = bkc1_1['Z']
        dfbkc1_1[basis+'_ccsd'] = bkc1_1['CCSD']

bkc1_1ccsd = dfbkc1_1.filter(regex='ccsd')

##bkc5.1.1##
dfbkc5_1_1=pd.DataFrame()

for basis in ['tz']:
        bkc5_1_1 = pd.read_csv('./'+basis+'.bkc5.1.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbkc5_1_1[basis+'_z'] = bkc5_1_1['Z']
        dfbkc5_1_1[basis+'_ccsd'] = bkc5_1_1['CCSD']

bkc5_1_1ccsd = dfbkc5_1_1.filter(regex='ccsd')

##bkc4.1##
dfbkc4_1=pd.DataFrame()

for basis in ['tz']:
        bkc4_1 = pd.read_csv('./'+basis+'.bkc4.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbkc4_1[basis+'_z'] = bkc4_1['Z']
        dfbkc4_1[basis+'_ccsd'] = bkc4_1['CCSD']

bkc4_1ccsd = dfbkc4_1.filter(regex='ccsd')

##bkc5.1##
dfbkc5_1=pd.DataFrame()

for basis in ['tz']:
        bkc5_1 = pd.read_csv('./'+basis+'.bkc5.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbkc5_1[basis+'_z'] = bkc5_1['Z']
        dfbkc5_1[basis+'_ccsd'] = bkc5_1['CCSD']

bkc5_1ccsd = dfbkc5_1.filter(regex='ccsd')

##bkc1.1-4.1##
dfbkc1_1_4_1=pd.DataFrame()

for basis in ['tz']:
        bkc1_1_4_1 = pd.read_csv('./'+basis+'.bkc1.1-4.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbkc1_1_4_1[basis+'_z'] = bkc1_1_4_1['Z']
        dfbkc1_1_4_1[basis+'_ccsd'] = bkc1_1_4_1['CCSD']

bkc1_1_4_1ccsd = dfbkc1_1_4_1.filter(regex='ccsd')

##CRENBL##
dfCRENBL=pd.DataFrame()

for basis in ['tz']:
        cCREN = pd.read_csv('./'+basis+'.CRENBL.csv',skip_blank_lines=True,skipinitialspace=True)
        dfCRENBL[basis+'_z'] = cCREN['Z']
        dfCRENBL[basis+'_ccsd'] = cCREN['CCSD']

CRENccsd = dfCRENBL.filter(regex='ccsd')

##LANL2DZ##
dfLANL2DZ=pd.DataFrame()

for basis in ['tz']:
        cLANL = pd.read_csv('./'+basis+'.LANL2DZ.csv',skip_blank_lines=True,skipinitialspace=True)
        dfLANL2DZ[basis+'_z'] = cLANL['Z']
        dfLANL2DZ[basis+'_ccsd'] = cLANL['CCSD']

LANLccsd = dfLANL2DZ.filter(regex='ccsd')

##SBKJC##
dfSBKJC=pd.DataFrame()

for basis in ['tz']:
        cSBKJ = pd.read_csv('./'+basis+'.SBKJC.csv',skip_blank_lines=True,skipinitialspace=True)
        dfSBKJC[basis+'_z'] = cSBKJ['Z']
        dfSBKJC[basis+'_ccsd'] = cSBKJ['CCSD']

SBKJccsd = dfSBKJC.filter(regex='ccsd')
###Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr
#
work = pd.DataFrame()
work['MDFSTU Raw'] = stuccsd['tz_ccsd'] 
work['MDFSTU proc'] = work['MDFSTU Raw'].values - -0.49982785 - -127.36411989
work['bk8.4.1 Raw'] = bk4ccsd['tz_ccsd']
work['bk8.4.1 proc'] = work['bk8.4.1 Raw'].values - -0.49982785 - -127.86642345
work['bk9.5.1 Raw'] = bk5ccsd['tz_ccsd']
work['bk9.5.1 proc'] = work['bk9.5.1 Raw'].values - -0.49982785 - -128.03219838
work['bkc1.1 Raw'] = bkc1_1ccsd['tz_ccsd']
work['bkc1.1 proc'] = work['bkc1.1 Raw'].values - -0.49982785 - -127.27054181
work['bkc4.1 Raw'] = bkc4_1ccsd['tz_ccsd']
work['bkc4.1 proc'] = work['bkc4.1 Raw'].values - -0.49982785 - -127.30464831
work['bkc5.1 Raw'] = bkc5_1ccsd['tz_ccsd']
work['bkc5.1 proc'] = work['bkc5.1 Raw'].values - -0.49982785 - -127.38233810
work['bkc5.1.1 Raw'] = bkc5_1_1ccsd['tz_ccsd']
work['bkc5.1.1 proc'] = work['bkc5.1.1 Raw'].values - -0.49982785 - -127.38498389
work['bkc1.1-4.1 Raw'] = bkc1_1_4_1ccsd['tz_ccsd']
work['bkc1.1-4.1 proc'] = work['bkc1.1-4.1 Raw'].values - -0.49982785 - -127.07496639
work['CRENBL Raw'] = CRENccsd['tz_ccsd']
work['CRENBL proc'] = work['CRENBL Raw'].values - -0.49982785 - -127.2680058
work['LANL2 Raw'] = LANLccsd['tz_ccsd']
work['LANL2 proc'] = work['LANL2 Raw'].values - -0.49982785 - -126.7144700
work['SBKJC Raw'] = SBKJccsd['tz_ccsd']
work['SBKJC proc'] = work['SBKJC Raw'].values - -0.49982785 --127.2329491

ff = pd.DataFrame()
#
#
##states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
##hf['SCF'] = states
##corr['Correlation'] = states
#
#


ff['z'] = aez['tz_z']
ff['ae'] = aebe['tz_BE']
ff['MDFSTU'] = work['MDFSTU proc']
ff['CRENBL'] = work['CRENBL proc']
ff['LANL2'] = work['LANL2 proc']
ff['SBKJC'] = work['SBKJC proc']
ff['bk8.4.1'] = work['bk8.4.1 proc']
ff['bk9.5.1'] = work['bk9.5.1 proc']
ff['bkc1.1'] = work['bkc1.1 proc']
ff['bkc4.1'] = work['bkc4.1 proc']
ff['bkc5.1'] = work['bkc5.1 proc']
ff['bkc5.1.1'] = work['bkc5.1.1 proc']
ff['bkc1.1-4.1'] = work['bkc1.1-4.1 proc']
revff = ff.iloc[::-1]

fff = pd.DataFrame()

fff['z'] = ff['z']
fff['MDFSTU error'] = (ff['MDFSTU'].values -ff['ae'].values)*toev
fff['CRENBL error'] = (ff['CRENBL'].values -ff['ae'].values)*toev
fff['LANL2 error'] = (ff['LANL2'].values -ff['ae'].values)*toev
fff['SBKJC error'] = (ff['SBKJC'].values -ff['ae'].values)*toev
fff['bk8.4.1 error'] = (ff['bk8.4.1'].values -ff['ae'].values)*toev
fff['bk9.5.1 error'] = (ff['bk9.5.1'].values -ff['ae'].values)*toev
fff['bkc1.1 error'] = (ff['bkc1.1'].values -ff['ae'].values)*toev
fff['bkc4.1 error'] = (ff['bkc4.1'].values -ff['ae'].values)*toev
fff['bkc5.1 error'] = (ff['bkc5.1'].values -ff['ae'].values)*toev
fff['bkc5.1.1 error'] = (ff['bkc5.1.1'].values -ff['ae'].values)*toev
fff['bkc1.1-4.1 error'] = (ff['bkc1.1-4.1'].values -ff['ae'].values)*toev
#print(fff.iloc[::-1])
print(fff.to_latex(index=False))
	
ecps = ['MDFSTU', 'LANL2', 'SBKJC', 'CRENBL', 'bkc5.1']

styles = {
        'UC'        :{'label': 'UC',       'color':'#e41a1c','linestyle':'--','dashes': (1000000,1)},
        'SBKJC'        :{'label': 'SBKJC',      'color':'#377eb8','linestyle':'--','dashes': (16,2)      },
        'MDFSTU'       :{'label': 'MDFSTU',      'color':'#ff7f00','linestyle':'--','dashes': (7,2)},
        'CRENBL'       :{'label': 'CRENBL',    'color':'#984ea3','linestyle':'--','dashes': (2.5,2) },
        'LANL2'      :{'label': 'LANL2',  'color':'#4daf4a','linestyle':'--','dashes': (13,2,4,2,13,9)},
        'bk9.5.1'      :{'label': 'bk9.5.1',    'color':'#DC0174','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bkc1.1'      :{'label': 'bkc1.1',    'color':'#34eb3a','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bkc4.1'      :{'label': 'bkc4.1',    'color':'#2c8019','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bkc5.1'      :{'label': 'ccECP',    'color':'#193f80','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bkc5.1.1'      :{'label': 'bkc5.1.1',    'color':'#ac2adb','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
#        'bkc1.1-4.1'      :{'label': 'bkc1.1-4.1',    'color':'#c92828','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        }

def init():
    font = {'family' : 'serif',
            'size': 20}
    lines = {'linewidth':3.5,'scale_dashes':False}
    axes = {'linewidth': 3}
    tick = {'major.size': 5,
            'major.width': 2,
            'labelsize': 18,
            'direction':'in',
            }
    legend = {'frameon':False,
              'fontsize':15,
              'handlelength':2.25,
              'labelspacing':0.25}

    mpl.rc('font',**font)
    mpl.rc('lines',**lines)
    mpl.rc('axes',**axes)
    mpl.rc('xtick',top=True,bottom=True,**tick)
    mpl.rc('ytick',left=True,right=True,**tick)
    mpl.rc('legend',**legend)

    mpl.rcParams['text.usetex'] = True
    mpl.rcParams.update({'figure.autolayout':True})
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    return fig,ax1

def plot(df):
    
    fig,ax =  init()
    ax.axhspan(-0.043,0.043,alpha=0.25,color='gray')
    ax.axhline(0.0,color='black')
    ax.set_xlabel('Bond Length (\AA)')
    ax.set_ylabel('Discrepancy (eV)')
    for i,ecp in enumerate(ecps):
        
        x = df['z'].values
        y = (df[ecp].values - df['ae'].values)*toev
        plt.plot(x,y,**styles[ecp])
    ax.set_xlim((x[0],x[-1]))
    ax.axvline(1.529,color='black',linestyle='--',linewidth=1.5,dashes=(2,2))
    plt.legend(loc='upper right')
    plt.savefig('PdH.pdf')
    plt.show()

plot(revff)