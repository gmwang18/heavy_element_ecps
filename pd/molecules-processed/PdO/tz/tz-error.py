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

##ccECP##
dfccECP=pd.DataFrame()

for basis in ['tz']:
        ccECP = pd.read_csv('./'+basis+'.ccECP.csv',skip_blank_lines=True,skipinitialspace=True)
        dfccECP[basis+'_z'] = ccECP['Z']
        dfccECP[basis+'_ccsd'] = ccECP['CCSD']

ccECPccsd = dfccECP.filter(regex='ccsd')

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
work['MDFSTU proc'] = work['MDFSTU Raw'].values --15.86703857- -127.36411989
work['ccECP Raw'] = ccECPccsd['tz_ccsd']
work['ccECP proc'] = work['ccECP Raw'].values --15.86703857- -127.38233810
work['CRENBL Raw'] = CRENccsd['tz_ccsd']
work['CRENBL proc'] = work['CRENBL Raw'].values --15.86703857- -127.2680058
work['LANL2 Raw'] = LANLccsd['tz_ccsd']
work['LANL2 proc'] = work['LANL2 Raw'].values --15.86703857- -126.7144700
work['SBKJC Raw'] = SBKJccsd['tz_ccsd']
work['SBKJC proc'] = work['SBKJC Raw'].values --15.86703857- -127.2329491

ff = pd.DataFrame()


#states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
#hf['SCF'] = states
#corr['Correlation'] = states




ff['z'] = aez['tz_z']
ff['ae'] = aebe['tz_BE']
ff['MDFSTU'] = work['MDFSTU proc']
ff['CRENBL'] = work['CRENBL proc']
ff['LANL2'] = work['LANL2 proc']
ff['SBKJC'] = work['SBKJC proc']
ff['ccECP'] = work['ccECP proc']
revff = ff.iloc[::-1]

fff = pd.DataFrame()

fff['z'] = ff['z']
fff['MDFSTU error'] = (ff['MDFSTU'].values -ff['ae'].values)*toev
fff['CRENBL error'] = (ff['CRENBL'].values -ff['ae'].values)*toev
fff['LANL2 error'] = (ff['LANL2'].values -ff['ae'].values)*toev
fff['SBKJC error'] = (ff['SBKJC'].values -ff['ae'].values)*toev
fff['ccECP error'] = (ff['ccECP'].values -ff['ae'].values)*toev
#print(fff.iloc[::-1])
print(fff.to_latex(index=False))
	
ecps = ['MDFSTU', 'LANL2', 'SBKJC', 'CRENBL', 'ccECP']

#styles = {
#        'UC'         :{'label': 'UC',       'color':'#e41a1c','linestyle':'--','dashes': (1000000,1)},
#        'LANL2'    :{'label': 'LANL2',  'color':'#4daf4a','linestyle':'--','dashes': (13,2,4,2,13,9)},
#        'SBKJC'        :{'label': 'SBKJC',      'color':'#377eb8','linestyle':'--','dashes': (16,2)      },
#        'MDFSTU'        :{'label': 'MDFSTU',      'color':'#ff7f00','linestyle':'--','dashes': (7,2)},
#        'CRENBL'       :{'label': 'CRENBL',    'color':'#984ea3','linestyle':'--','dashes': (2.5,2) },
#        'ccECP'      :{'label': 'ccECP',    'color':'#193f80','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
#        }

styles = {
'UC'        :{'label': 'UC',       'color':'#e41a1c','linestyle':'-'},
'CRENBL'    :{'label': 'CRENBL','color':'#ff7f00','linestyle':'--','dashes': (8,5,1,3)},
'LANL2'     :{'label': 'LANL2',    'color':'#377eb8','linestyle':'-','dashes': (3,1,1,2) },
'MDFSTU'    :{'label': 'MDFSTU',      'color':'#984ea3','linestyle':'--','dashes': (6,3)     },
'SBKJC'     :{'label': 'SBKJC',    'color':'#DC0174','linestyle':'-','dashes': (3,1,1,2) },
'ccECP'        :{'label': 'ccECP-AREP',      'color':'#009900','linestyle':'--','dashes': (4,2,1,2)     },
}

def init():
    font = {'family' : 'serif',
            'size': 20}
    lines = {'linewidth':2.0}
    axes = {'linewidth': 3}
    tick = {'major.size': 5,
            'major.width':2}
    legend = {'frameon':False,
              'fontsize':18}

    mpl.rc('font',**font)
    mpl.rc('lines',**lines)
    mpl.rc('axes',**axes)
    mpl.rc('xtick',**tick)
    mpl.rc('ytick',**tick)
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
    ax.set(title='PdO tz Discrepancies')
    ax.axvline(1.835,color='black',linestyle='--',linewidth=1.5,dashes=(2,2))
    plt.legend(loc='best',ncol=2,prop={'size': 12})
    plt.savefig('PdO.pdf')
    plt.savefig('PdO.png', dpi=800)
    plt.show()

plot(revff)
