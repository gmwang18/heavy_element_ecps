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

##stuttgart##
dfstu=pd.DataFrame()

for basis in ['tz']:
        b = pd.read_csv('./'+basis+'.mdfstu.csv',skip_blank_lines=True,skipinitialspace=True)
        dfstu[basis+'_z'] = b['Z']
        dfstu[basis+'_ccsd'] = b['CCSD']

stuccsd = dfstu.filter(regex='ccsd')

##UC##
dfuc=pd.DataFrame()

for basis in ['tz']:
        uc = pd.read_csv('./'+basis+'.uc.csv',skip_blank_lines=True,skipinitialspace=True)
        dfuc[basis+'_z'] = uc['Z']
        dfuc[basis+'_ccsd'] = uc['CCSD']

ucccsd = dfuc.filter(regex='ccsd')

##bk8.4.1##
dfbk4_1=pd.DataFrame()

for basis in ['tz']:
        c4 = pd.read_csv('./'+basis+'.bk8.4.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk4_1[basis+'_z'] = c4['Z']
        dfbk4_1[basis+'_ccsd'] = c4['CCSD']

bk4ccsd = dfbk4_1.filter(regex='ccsd')

##bk9.5.1##
dfbk5_1=pd.DataFrame()

for basis in ['tz']:
        c5 = pd.read_csv('./'+basis+'.bk9.5.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk5_1[basis+'_z'] = c5['Z']
        dfbk5_1[basis+'_ccsd'] = c5['CCSD']

bk5ccsd = dfbk5_1.filter(regex='ccsd')

##bkc1.1##
dfbkc1_1=pd.DataFrame()

for basis in ['tz']:
        bkc1 = pd.read_csv('./'+basis+'.bkc1.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbkc1_1[basis+'_z'] = bkc1['Z']
        dfbkc1_1[basis+'_ccsd'] = bkc1['CCSD']

bkc1ccsd = dfbkc1_1.filter(regex='ccsd')

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

##bkc5.1.1##
dfbkc5_1_1=pd.DataFrame()

for basis in ['tz']:
        bkc5_1_1 = pd.read_csv('./'+basis+'.bkc5.1.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbkc5_1_1[basis+'_z'] = bkc5_1_1['Z']
        dfbkc5_1_1[basis+'_ccsd'] = bkc5_1_1['CCSD']

bkc5_1_1ccsd = dfbkc5_1_1.filter(regex='ccsd')

##bk16.1##
dfbk16_1=pd.DataFrame()

for basis in ['tz']:
        bk16_1 = pd.read_csv('./'+basis+'.bk16.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_1[basis+'_z'] = bk16_1['Z']
        dfbk16_1[basis+'_ccsd'] = bk16_1['CCSD']

bk16_1ccsd = dfbk16_1.filter(regex='ccsd')

##bk16.3##
dfbk16_3=pd.DataFrame()

for basis in ['tz']:
        bk16_3 = pd.read_csv('./'+basis+'.bk16.3.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_3[basis+'_z'] = bk16_3['Z']
        dfbk16_3[basis+'_ccsd'] = bk16_3['CCSD']

bk16_3ccsd = dfbk16_3.filter(regex='ccsd')

##bk16.4##
dfbk16_4=pd.DataFrame()

for basis in ['tz']:
        bk16_4 = pd.read_csv('./'+basis+'.bk16.4.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_4[basis+'_z'] = bk16_4['Z']
        dfbk16_4[basis+'_ccsd'] = bk16_4['CCSD']

bk16_4ccsd = dfbk16_4.filter(regex='ccsd')

##bk16.6##
dfbk16_6=pd.DataFrame()

for basis in ['tz']:
        bk16_6 = pd.read_csv('./'+basis+'.bk16.6.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_6[basis+'_z'] = bk16_6['Z']
        dfbk16_6[basis+'_ccsd'] = bk16_6['CCSD']

bk16_6ccsd = dfbk16_6.filter(regex='ccsd')

##bk16.7##
dfbk16_7=pd.DataFrame()

for basis in ['tz']:
        bk16_7 = pd.read_csv('./'+basis+'.bk16.7.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_7[basis+'_z'] = bk16_7['Z']
        dfbk16_7[basis+'_ccsd'] = bk16_7['CCSD']

bk16_7ccsd = dfbk16_7.filter(regex='ccsd')

##bk16.8##
dfbk16_8=pd.DataFrame()

for basis in ['tz']:
        bk16_8 = pd.read_csv('./'+basis+'.bk16.8.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_8[basis+'_z'] = bk16_8['Z']
        dfbk16_8[basis+'_ccsd'] = bk16_8['CCSD']

bk16_8ccsd = dfbk16_8.filter(regex='ccsd')

##bk16.9##
dfbk16_9=pd.DataFrame()

for basis in ['tz']:
        bk16_9 = pd.read_csv('./'+basis+'.bk16.9.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_9[basis+'_z'] = bk16_9['Z']
        dfbk16_9[basis+'_ccsd'] = bk16_9['CCSD']

bk16_9ccsd = dfbk16_9.filter(regex='ccsd')

##bk16.10##
dfbk16_10=pd.DataFrame()

for basis in ['tz']:
        bk16_10 = pd.read_csv('./'+basis+'.bk16.10.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_10[basis+'_z'] = bk16_10['Z']
        dfbk16_10[basis+'_ccsd'] = bk16_10['CCSD']

bk16_10ccsd = dfbk16_10.filter(regex='ccsd')

##bk16.11##
dfbk16_11=pd.DataFrame()

for basis in ['tz']:
        bk16_11 = pd.read_csv('./'+basis+'.bk16.11.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_11[basis+'_z'] = bk16_11['Z']
        dfbk16_11[basis+'_ccsd'] = bk16_11['CCSD']

bk16_11ccsd = dfbk16_11.filter(regex='ccsd')

##bk16.12##
dfbk16_12=pd.DataFrame()

for basis in ['tz']:
        bk16_12 = pd.read_csv('./'+basis+'.bk16.12.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_12[basis+'_z'] = bk16_12['Z']
        dfbk16_12[basis+'_ccsd'] = bk16_12['CCSD']

bk16_12ccsd = dfbk16_12.filter(regex='ccsd')

##bk16.13##
dfbk16_13=pd.DataFrame()

for basis in ['tz']:
        bk16_13 = pd.read_csv('./'+basis+'.bk16.13.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_13[basis+'_z'] = bk16_13['Z']
        dfbk16_13[basis+'_ccsd'] = bk16_13['CCSD']

bk16_13ccsd = dfbk16_13.filter(regex='ccsd')

##bk16.14##
dfbk16_14=pd.DataFrame()

for basis in ['tz']:
        bk16_14 = pd.read_csv('./'+basis+'.bk16.14.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk16_14[basis+'_z'] = bk16_14['Z']
        dfbk16_14[basis+'_ccsd'] = bk16_14['CCSD']

bk16_14ccsd = dfbk16_14.filter(regex='ccsd')

##bk24.1##
dfbk24_1=pd.DataFrame()

for basis in ['tz']:
        bk24_1 = pd.read_csv('./'+basis+'.bk24.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk24_1[basis+'_z'] = bk24_1['Z']
        dfbk24_1[basis+'_ccsd'] = bk24_1['CCSD']

bk24_1ccsd = dfbk24_1.filter(regex='ccsd')

##bk24.2##
dfbk24_2=pd.DataFrame()

for basis in ['tz']:
        bk24_2 = pd.read_csv('./'+basis+'.bk24.2.csv',skip_blank_lines=True,skipinitialspace=True)
        dfbk24_2[basis+'_z'] = bk24_2['Z']
        dfbk24_2[basis+'_ccsd'] = bk24_2['CCSD']

bk24_2ccsd = dfbk24_2.filter(regex='ccsd')

##fbk1.1##
dffbk1_1=pd.DataFrame()

for basis in ['tz']:
        fbk1 = pd.read_csv('./'+basis+'.fbk1.1.csv',skip_blank_lines=True,skipinitialspace=True)
        dffbk1_1[basis+'_z'] = fbk1['Z']
        dffbk1_1[basis+'_ccsd'] = fbk1['CCSD']

fbk1ccsd = dffbk1_1.filter(regex='ccsd')


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

oxy = -15.86703857

work = pd.DataFrame()
work['UC Raw'] = ucccsd['tz_ccsd'] 
work['UC proc'] = work['UC Raw'].values --75.03675736- -5043.565379
work['MDFSTU Raw'] = stuccsd['tz_ccsd'] 
work['MDFSTU proc'] = work['MDFSTU Raw'].values -oxy- -127.36411989
work['bk8.4.1 Raw'] = bk4ccsd['tz_ccsd']
work['bk8.4.1 proc'] = work['bk8.4.1 Raw'].values -oxy-  -127.86642345
work['bk9.5.1 Raw'] = bk5ccsd['tz_ccsd']
work['bk9.5.1 proc'] = work['bk9.5.1 Raw'].values -oxy- -128.03219838
work['bkc1.1 Raw'] = bkc1ccsd['tz_ccsd']
work['bkc1.1 proc'] = work['bkc1.1 Raw'].values -oxy- -127.27054181
work['fbk1.1 Raw'] = fbk1ccsd['tz_ccsd']
work['fbk1.1 proc'] = work['fbk1.1 Raw'].values -oxy- -127.63406525
work['bkc4.1 Raw'] = bkc4_1ccsd['tz_ccsd']
work['bkc4.1 proc'] = work['bkc4.1 Raw'].values -oxy- -127.30464831 
work['bkc5.1 Raw'] = bkc5_1ccsd['tz_ccsd']
work['bkc5.1 proc'] = work['bkc5.1 Raw'].values -oxy- -127.38233810
work['bkc5.1.1 Raw'] = bkc5_1_1ccsd['tz_ccsd']
work['bkc5.1.1 proc'] = work['bkc5.1.1 Raw'].values -oxy- -127.38498389
work['bk16.1 Raw'] = bk16_1ccsd['tz_ccsd']
work['bk16.1 proc'] = work['bk16.1 Raw'].values -oxy--127.64119876
work['bk16.3 Raw'] = bk16_3ccsd['tz_ccsd']
work['bk16.3 proc'] = work['bk16.3 Raw'].values -oxy --127.59567863
work['bk16.4 Raw'] = bk16_4ccsd['tz_ccsd']
work['bk16.4 proc'] = work['bk16.4 Raw'].values -oxy --127.62789404
work['bk16.6 Raw'] = bk16_6ccsd['tz_ccsd']
work['bk16.6 proc'] = work['bk16.6 Raw'].values -oxy --127.59641067
work['bk16.7 Raw'] = bk16_7ccsd['tz_ccsd']
work['bk16.7 proc'] = work['bk16.7 Raw'].values -oxy --127.62839640
work['bk16.8 Raw'] = bk16_8ccsd['tz_ccsd']
work['bk16.8 proc'] = work['bk16.8 Raw'].values -oxy --127.56744143
work['bk16.9 Raw'] = bk16_9ccsd['tz_ccsd']
work['bk16.9 proc'] = work['bk16.9 Raw'].values -oxy --127.41251700
work['bk16.10 Raw'] = bk16_10ccsd['tz_ccsd']
work['bk16.10 proc'] = work['bk16.10 Raw'].values -oxy --127.19309069
work['bk16.11 Raw'] = bk16_11ccsd['tz_ccsd']
work['bk16.11 proc'] = work['bk16.11 Raw'].values -oxy --127.10305807
work['bk16.12 Raw'] = bk16_12ccsd['tz_ccsd']
work['bk16.12 proc'] = work['bk16.12 Raw'].values -oxy --127.26049020
work['bk16.13 Raw'] = bk16_13ccsd['tz_ccsd']
work['bk16.13 proc'] = work['bk16.13 Raw'].values -oxy --127.35117975
work['bk16.14 Raw'] = bk16_14ccsd['tz_ccsd']
work['bk16.14 proc'] = work['bk16.14 Raw'].values -oxy --127.21373712
work['bk24.1 Raw'] = bk24_1ccsd['tz_ccsd']
work['bk24.1 proc'] = work['bk24.1 Raw'].values -oxy --127.63756444
work['bk24.2 Raw'] = bk24_2ccsd['tz_ccsd']
work['bk24.2 proc'] = work['bk24.2 Raw'].values -oxy --127.63756444
work['CRENBL Raw'] = CRENccsd['tz_ccsd']
work['CRENBL proc'] = work['CRENBL Raw'].values -oxy- -127.2680058
work['LANL2 Raw'] = LANLccsd['tz_ccsd']
work['LANL2 proc'] = work['LANL2 Raw'].values -oxy- -126.7144700
work['SBKJC Raw'] = SBKJccsd['tz_ccsd']
work['SBKJC proc'] = work['SBKJC Raw'].values -oxy- -127.2329491

ff = pd.DataFrame()


#states=['[Ar]$3d**{10}4s^24p1$','[Ar]$3d^{10}4s^14p2$','[Ar]$3d^{10}4s^2$','[Ar]$3d^{10}4s^14p1$', '[Ar]$3d^{10}4s^1$','[Ar]$3d^{10}$','[Ar]$3d^9$','[Ar]$3d^8$','[Ar]$3d^7$','[Ar]$3d^6$','[Ar]$3d^5$','[Ar]$3d^{10}4s^24p2$']
#hf['SCF'] = states
#corr['Correlation'] = states




ff['z'] = aez['tz_z']
ff['ae'] = aebe['tz_BE']
ff['UC'] = work['UC proc']
ff['MDFSTU'] = work['MDFSTU proc']
ff['CRENBL'] = work['CRENBL proc']
ff['LANL2'] = work['LANL2 proc']
ff['SBKJC'] = work['SBKJC proc']
ff['bk8.4.1'] = work['bk8.4.1 proc']
ff['bk9.5.1'] = work['bk9.5.1 proc']
ff['bkc1.1'] = work['bkc1.1 proc']
ff['fbk1.1'] = work['fbk1.1 proc']
ff['bkc4.1'] = work['bkc4.1 proc']
ff['bkc5.1'] = work['bkc5.1 proc']
ff['bkc5.1.1'] = work['bkc5.1.1 proc']
ff['bk16.1'] = work['bk16.1 proc']
ff['bk16.3'] = work['bk16.3 proc']
ff['bk16.4'] = work['bk16.4 proc']
ff['bk16.6'] = work['bk16.6 proc']
ff['bk16.7'] = work['bk16.7 proc']
ff['bk16.8'] = work['bk16.8 proc']
ff['bk16.9'] = work['bk16.9 proc']
ff['bk16.10'] = work['bk16.10 proc']
ff['bk16.11'] = work['bk16.11 proc']
ff['bk16.12'] = work['bk16.12 proc']
ff['bk16.13'] = work['bk16.13 proc']
ff['bk16.14'] = work['bk16.14 proc']
ff['bk24.1'] = work['bk24.1 proc']
ff['bk24.2'] = work['bk24.2 proc']
revff = ff.iloc[::-1]

fff = pd.DataFrame()

fff['z'] = ff['z']
fff['UC error'] = (ff['UC'].values -ff['ae'].values)*toev
fff['MDFSTU error'] = (ff['MDFSTU'].values -ff['ae'].values)*toev
fff['CRENBL error'] = (ff['CRENBL'].values -ff['ae'].values)*toev
fff['LANL2 error'] = (ff['LANL2'].values -ff['ae'].values)*toev
fff['SBKJC error'] = (ff['SBKJC'].values -ff['ae'].values)*toev
#fff['bk8.4.1 error'] = (ff['bk8.4.1'].values -ff['ae'].values)*toev
#fff['bk9.5.1 error'] = (ff['bk9.5.1'].values -ff['ae'].values)*toev
#fff['bkc1.1 error'] = (ff['bkc1.1'].values -ff['ae'].values)*toev
#fff['fbk1.1 error'] = (ff['fbk1.1'].values -ff['ae'].values)*toev
#fff['bkc4.1 error'] = (ff['bkc4.1'].values -ff['ae'].values)*toev
fff['bkc5.1 error'] = (ff['bkc5.1'].values -ff['ae'].values)*toev
fff['bk16.12 error'] = (ff['bk16.12'].values -ff['ae'].values)*toev
fff['bk16.14 error'] = (ff['bk16.14'].values -ff['ae'].values)*toev
#fff['bkc5.1.1 error'] = (ff['bkc5.1.1'].values -ff['ae'].values)*toev
#fff['bk16.1 error'] = (ff['bk16.1'].values -ff['ae'].values)*toev
#fff['bk16.3 error'] = (ff['bk16.3'].values -ff['ae'].values)*toev
#fff['bk16.4 error'] = (ff['bk16.4'].values -ff['ae'].values)*toev
#fff['bk16.6 error'] = (ff['bk16.6'].values -ff['ae'].values)*toev
#fff['bk24.1 error'] = (ff['bk24.1'].values -ff['ae'].values)*toev
#fff['bk24.2 error'] = (ff['bk24.2'].values -ff['ae'].values)*toev
#print(fff.iloc[::-1])
print(fff.to_latex(index=False))
	
ecps = ['UC', 'MDFSTU', 'LANL2', 'SBKJC', 'CRENBL', 'bkc5.1', 'bk16.12']

styles = {
        'UC'         :{'label': 'UC',       'color':'#e41a1c','linestyle':'--','dashes': (1000000,1)},
        'SBKJC'        :{'label': 'SBKJC',      'color':'#377eb8','linestyle':'--','dashes': (16,2)      },
        'MDFSTU'        :{'label': 'MDFSTU',      'color':'#ff7f00','linestyle':'--','dashes': (7,2)},
        'CRENBL'       :{'label': 'CRENBL',    'color':'#984ea3','linestyle':'--','dashes': (2.5,2) },
        'LANL2'    :{'label': 'LANL2',  'color':'#4daf4a','linestyle':'--','dashes': (13,2,4,2,13,9)},
        'bk9.5.1'      :{'label': 'bk9.5.1',    'color':'#DC0174','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bkc5.1'      :{'label': 'ccECP',    'color':'#193f80','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bk16.6'      :{'label': 'bk16.6',    'color':'#444444','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bk16.7'      :{'label': 'bk16.7',    'color':'#ac2adb','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bk16.8'      :{'label': 'bk16.8',    'color':'#1ddddd','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bk16.9'      :{'label': 'bk16.9',    'color':'#34eb3a','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bk16.10'      :{'label': 'bk16.10',    'color':'#1ddddd','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bk16.11'      :{'label': 'bk16.11',    'color':'#2c8b3a','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bk16.12'      :{'label': 'bk16.12',    'color':'#34eb3a','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        'bk16.14'      :{'label': 'bk16.14',    'color':'#2c8019','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
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
    ax.axvline(1.835,color='black',linestyle='--',linewidth=1.5,dashes=(2,2))
    plt.legend(loc='upper right')
    plt.savefig('PdO.pdf')
    plt.show()

plot(revff)
