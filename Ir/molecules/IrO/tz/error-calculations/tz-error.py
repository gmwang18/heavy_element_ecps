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
        dfae[basis+'_z'] = a1['Z']
        dfae[basis+'_ccsd'] = a1['CCSD']


aez = dfae.filter(regex='z')
aeccsd = dfae.filter(regex='ccsd')

##Stuttgart##
dfstu=pd.DataFrame()

for basis in ['tz']:
        b = pd.read_csv('./'+basis+'.mdfstu.csv',skip_blank_lines=True,skipinitialspace=True)
        dfstu[basis+'_z'] = b['Z']
        dfstu[basis+'_ccsd'] = b['CCSD']

stuccsd = dfstu.filter(regex='ccsd')

##bk1.6##
dfbk1_6=pd.DataFrame()

for basis in ['tz']:
        bk1_6 = pd.read_csv('./'+basis+'.bk1.6.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk1_6[basis+'_z'] = bk1_6['Z']
        dfbk1_6[basis+'_ccsd'] = bk1_6['CCSD']

bk1_6ccsd = dfbk1_6.filter(regex='ccsd')

##bk1.7##
dfbk1_7=pd.DataFrame()

for basis in ['tz']:
        bk1_7 = pd.read_csv('./'+basis+'.bk1.7.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk1_7[basis+'_z'] = bk1_7['Z']
        dfbk1_7[basis+'_ccsd'] = bk1_7['CCSD']

bk1_7ccsd = dfbk1_7.filter(regex='ccsd')

##bk1.8##
dfbk1_8=pd.DataFrame()

for basis in ['tz']:
        bk1_8 = pd.read_csv('./'+basis+'.bk1.8.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk1_8[basis+'_z'] = bk1_8['Z']
        dfbk1_8[basis+'_ccsd'] = bk1_8['CCSD']

bk1_8ccsd = dfbk1_8.filter(regex='ccsd')

##bk1.9##
dfbk1_9=pd.DataFrame()

for basis in ['tz']:
        bk1_9 = pd.read_csv('./'+basis+'.bk1.9.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk1_9[basis+'_z'] = bk1_9['Z']
        dfbk1_9[basis+'_ccsd'] = bk1_9['CCSD']

bk1_9ccsd = dfbk1_9.filter(regex='ccsd')

##bk2.3##
dfbk2_3=pd.DataFrame()

for basis in ['tz']:
        bk2_3 = pd.read_csv('./'+basis+'.bk2.3.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk2_3[basis+'_z'] = bk2_3['Z']
        dfbk2_3[basis+'_ccsd'] = bk2_3['CCSD']

bk2_3ccsd = dfbk2_3.filter(regex='ccsd')

##bk2.4##
dfbk2_4=pd.DataFrame()

for basis in ['tz']:
        bk2_4 = pd.read_csv('./'+basis+'.bk2.4.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk2_4[basis+'_z'] = bk2_4['Z']
        dfbk2_4[basis+'_ccsd'] = bk2_4['CCSD']

bk2_4ccsd = dfbk2_4.filter(regex='ccsd')

##bk2.5##
dfbk2_5=pd.DataFrame()

for basis in ['tz']:
        bk2_5 = pd.read_csv('./'+basis+'.bk2.5.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk2_5[basis+'_z'] = bk2_5['Z']
        dfbk2_5[basis+'_ccsd'] = bk2_5['CCSD']

bk2_5ccsd = dfbk2_5.filter(regex='ccsd')

##bk2.6##
dfbk2_6=pd.DataFrame()

for basis in ['tz']:
        bk2_6 = pd.read_csv('./'+basis+'.bk2.6.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk2_6[basis+'_z'] = bk2_6['Z']
        dfbk2_6[basis+'_ccsd'] = bk2_6['CCSD']

bk2_6ccsd = dfbk2_6.filter(regex='ccsd')

##CRENBL##
dfCRENBL=pd.DataFrame()

for basis in ['tz']:
        cCREN = pd.read_csv('./'+basis+'.CRENBL.csv',skip_blank_lines=True,skipinitialspace=True)
        dfCRENBL[basis+'_z'] = cCREN['Z']
        dfCRENBL[basis+'_ccsd'] = cCREN['CCSD']

CRENccsd = dfCRENBL.filter(regex='ccsd')

##UC##
dfUC=pd.DataFrame()

for basis in ['tz']:
        cUC = pd.read_csv('./'+basis+'.UC.csv',skip_blank_lines=True,skipinitialspace=True)
        dfUC[basis+'_z'] = cUC['Z']
        dfUC[basis+'_ccsd'] = cUC['CCSD']

UCccsd = dfUC.filter(regex='ccsd')

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
work['AE Raw'] = aeccsd['tz_ccsd']
work['AE proc'] = work['AE Raw'].values  --75.09181489 --17830.04119
work['UC Raw'] = UCccsd['tz_ccsd']
work['UC proc'] = work['UC Raw'].values  - -75.03665265 --17827.49830
work['MDFSTU Raw'] = stuccsd['tz_ccsd'] 
work['MDFSTU proc'] = work['MDFSTU Raw'].values --15.86568094 --104.2302524
work['bk1.6 Raw'] = bk1_6ccsd['tz_ccsd']
work['bk1.6 proc'] = work['bk1.6 Raw'].values --15.86568094 --104.3720361
work['bk1.7 Raw'] = bk1_7ccsd['tz_ccsd']
work['bk1.7 proc'] = work['bk1.7 Raw'].values --15.86568094 --104.3727376
work['bk1.8 Raw'] = bk1_8ccsd['tz_ccsd']
work['bk1.8 proc'] = work['bk1.8 Raw'].values --15.86568094 --104.3975152
work['bk1.9 Raw'] = bk1_9ccsd['tz_ccsd']
work['bk1.9 proc'] = work['bk1.9 Raw'].values --15.86568094 --104.4239803
work['bk2.3 Raw'] = bk2_3ccsd['tz_ccsd']
work['bk2.3 proc'] = work['bk2.3 Raw'].values --15.86568094 --104.3906077
work['bk2.4 Raw'] = bk2_4ccsd['tz_ccsd']
work['bk2.4 proc'] = work['bk2.4 Raw'].values --15.86568094 --104.3530433
work['bk2.5 Raw'] = bk2_5ccsd['tz_ccsd']
work['bk2.5 proc'] = work['bk2.5 Raw'].values --15.86568094 --104.3617643
work['bk2.6 Raw'] = bk2_6ccsd['tz_ccsd']
work['bk2.6 proc'] = work['bk2.6 Raw'].values --15.86568094 --104.3776773
work['CRENBL Raw'] = CRENccsd['tz_ccsd']
work['CRENBL proc'] = work['CRENBL Raw'].values --15.86568094 --104.5952082
work['LANL2 Raw'] = LANLccsd['tz_ccsd']
work['LANL2 proc'] = work['LANL2 Raw'].values --15.86568094 --104.55017050
work['SBKJC Raw'] = SBKJccsd['tz_ccsd']
work['SBKJC proc'] = work['SBKJC Raw'].values --15.86568094 --104.5826961

ff = pd.DataFrame()
#
#
##states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
##hf['SCF'] = states
##corr['Correlation'] = states
#
#


ff['z'] = aez['tz_z']
ff['ae'] = work['AE proc']
ff['UC'] = work['UC proc']
ff['MDFSTU'] = work['MDFSTU proc']
ff['CRENBL'] = work['CRENBL proc']
ff['LANL2'] = work['LANL2 proc']
ff['SBKJC'] = work['SBKJC proc']
ff['bk1.6'] = work['bk1.6 proc']
ff['bk1.7'] = work['bk1.7 proc']
ff['bk1.8'] = work['bk1.8 proc']
ff['bk1.9'] = work['bk1.9 proc']
ff['bk2.3'] = work['bk2.3 proc']
ff['bk2.4'] = work['bk2.4 proc']
ff['bk2.5'] = work['bk2.5 proc']
ff['bk2.6'] = work['bk2.6 proc']

fff = pd.DataFrame()

fff['z'] = ff['z']
fff['AE BE'] = ff['ae'].values*toev
fff['UC error'] = ( ff['UC'].values- ff['ae'].values )*toev  
fff['MDFSTU error'] = ( ff['MDFSTU'].values- ff['ae'].values )*toev  
fff['CRENBL error'] = ( ff['CRENBL'].values- ff['ae'].values )*toev  
fff['LANL2 error'] =  (  ff['LANL2'].values- ff['ae'].values )*toev  
fff['SBKJC error'] =  (  ff['SBKJC'].values- ff['ae'].values )*toev  
fff['bk1.6 error'] =  (  ff['bk1.6'].values- ff['ae'].values )*toev  
fff['bk1.7 error'] =  (  ff['bk1.7'].values- ff['ae'].values )*toev  
fff['bk1.8 error'] =  (  ff['bk1.8'].values- ff['ae'].values )*toev  
fff['bk1.9 error'] =  (  ff['bk1.9'].values- ff['ae'].values )*toev  
fff['bk2.3 error'] =  (  ff['bk2.3'].values- ff['ae'].values )*toev  
fff['bk2.4 error'] =  (  ff['bk2.4'].values- ff['ae'].values )*toev  
fff['bk2.5 error'] =  (  ff['bk2.5'].values- ff['ae'].values )*toev  
fff['bk2.6 error'] =  (  ff['bk2.6'].values- ff['ae'].values )*toev  
#print(fff.iloc[::-1])
print(fff.to_latex(index=False))
	
ecps = ['MDFSTU', 'LANL2', 'SBKJC', 'CRENBL','bk2.6', 'UC']

styles = {
        'UC'        :{'label': 'UC',       'color':'#e41a1c','linestyle':'--','dashes': (1000000,1)},
        'LANL2'    :{'label': 'LANL2',  'color':'#4daf4a','linestyle':'--','dashes': (13,2,4,2,13,9)},
        'SBKJC'        :{'label': 'SBKJC',      'color':'#377eb8','linestyle':'--','dashes': (16,2)      },
        'MDFSTU'       :{'label': 'MDFSTU',      'color':'#ff7f00','linestyle':'--','dashes': (7,2)},
        'CRENBL'       :{'label': 'CRENBL',    'color':'#984ea3','linestyle':'--','dashes': (2.5,2) },
        'bk1.7'      :{'label': 'bk1.7',  'color':'#1bbbbb','linestyle':'--','dashes': (13,2,4,2,13,9)},
        'bk1.9'      :{'label': 'bk1.9',  'color':'#100000','linestyle':'--','dashes': (13,2,4,2,13,9)},
        'bk2.6'      :{'label': 'ccECP',  'color':'#193f80','linestyle':'--','dashes': (13,2,4,2,13,9)},
        }

def init():
    font = {'family' : 'serif',
            'size': 18}
    lines = {'linewidth':3.5,'scale_dashes':False}
    axes = {'linewidth': 3}
    tick = {'major.size': 5,
            'major.width': 2,
            'labelsize': 18,
            'direction':'in',
            }
    legend = {'frameon':False,
              'fontsize':16,
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
    ax.axvline(1.7231,color='black',linestyle='--',linewidth=1.5,dashes=(2,2))
    plt.legend(loc='upper right')
    plt.savefig('IrO.pdf')
    plt.show()

plot(ff)
