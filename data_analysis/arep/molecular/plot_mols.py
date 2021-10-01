#!/usr/bin/env python

import sys
import os
import glob
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import pickle

### === Define styles ===
#ecps = ['UC','BFD','MWBSTU','MDFSTU','SBKJC','CRENBL','LANL2DZ','ccECP']
styles={
'UC'		:{'label':'UC',		'color':'#ff0000','linestyle':'-'			},
'BFD'		:{'label':'BFD',	'color':'#0000ff','linestyle':'--','dashes':(8,1)	},
'MDFSTU'	:{'label':'MDFSTU',	'color':'#ff6600','linestyle':'--','dashes':(4,1)	},
'MWBSTU'	:{'label':'MWBSTU',	'color':'#ff33cc','linestyle':'--','dashes':(4,1,1,1)	},
'CRENBS'	:{'label':'CRENBS',	'color':'#2f4f4f','linestyle':'--','dashes':(6,3)	},
'CRENBL'	:{'label':'CRENBL',	'color':'#2f4f4f','linestyle':'--','dashes':(6,3)	},
'SBKJC'		:{'label':'SBKJC',	'color':'#1e90ff','linestyle':'--','dashes':(2,1,8,1)	},
'LANL2'		:{'label':'LANL2',	'color':'#a52a2a','linestyle':'--','dashes':(1,1)	},
'ccECP'	        :{'label':'ccECP',	'color':'#009900','linestyle':'--','dashes':(8,1,1,1,1,1)},
}

toeV = 27.211386

### === Get the molecule names in the path ===
systems = glob.glob("*.csv")
mols=[]
### Get rid of csv extension
for mol in systems:
	mols.append(os.path.splitext(mol)[0])
#print(mols)

### === Equilibrium positions to be plotted === 
req = {
'TeH_QZ': 1.6, # Tentative
'AgH_5Z': 1.6, # Tentative
'AgO_5Z': 2.0, # Tentative
'AuH_TZ': 1.6, # Tentative
'AuO_TZ': 1.9, # Tentative
'BiH_TZ': 1.8, # Tentative
'BiO_TZ': 1.9, # Tentative
'MoO_TZ': 1.7,
'MoH_TZ': 2.12,
'IH_QZ' : 1.6020789274002896,
'IO_QZ' : 1.8388286072136575,
'WH_TZ' : 1.7003525781479623,
'WO_TZ' : 1.66381039175619,
'IrH_TZ': 1.5,
'IrO_TZ': 1.7,
'PdH_TZ': 1.5,
'PdO_TZ': 1.8,
'TeO_QZ': 1.8114,
}

def init():
    font   = {'family' : 'serif', 'size': 17}
    lines  = {'linewidth': 2.5}
    axes   = {'linewidth': 2.0}    # border width
    tick   = {'major.size': 2, 'major.width':2}
    legend = {'frameon':True, 'fontsize':15.0, 'handlelength':2.30, 'labelspacing':0.30, 'handletextpad':0.4, 'loc':'best', 'facecolor':'white', 'framealpha':1.00, 'edgecolor':'#f2f2f2'}
    mpl.rc('font',**font)
    mpl.rc('lines',**lines)
    mpl.rc('axes',**axes)
    mpl.rc('xtick',**tick)
    mpl.rc('ytick',**tick)
    mpl.rc('legend',**legend)
    mpl.rcParams['text.usetex'] = True
    mpl.rcParams.update({'figure.autolayout':True})
    fig = plt.figure()
    fig.set_size_inches(7.17, 5.38)   # Default 6.4, 4.8
    ax1 = fig.add_subplot(111) # row, column, nth plot
    ax1.tick_params(direction='in', length=6, width=2, which='major', pad=6)
    ax1.tick_params(direction='in', length=4, width=1, which='minor', pad=6)
    ax1.grid(b=None, which='major', axis='both', alpha=0.10)

    return fig, ax1

def get_data(mol):
    files = glob.glob(mol+'*.csv')
    #files = [mol]
    #print(files)
    if len(files) > 1:
        print('Too many csv files for {}'.format(mol))
        sys.exit()
    elif len(files) == 0:
        df = pd.DataFrame()
    else:
        df = pd.read_csv(files[0],index_col=0)
    df.dropna(inplace=True)
    for col in df:
        df[col] = df[col]*toeV
    ecps=list(df.columns)
    if 'AE' in ecps: ecps.remove('AE')
    #print(df)
    #print(ecps)
    return df,ecps

def plot(mol,savefig=True,show=False):
    print('Molecule: {}'.format(mol))
    fig, ax = init()
    df, ecps = get_data(mol)

    ax.axhspan(-0.043, 0.043, alpha=0.25, color='gray')
    ax.axhline(0.0,linewidth=1.0,color='black')
    ax.set_xlabel('Bond Length (\AA)')
    ax.set_ylabel('Discrepancy $\Delta(r)$ (eV)')
    for i,ecp in enumerate(ecps):
        x = df.index.values
        y = df[ecp].values - df['AE'].values
        plt.plot(x,y,**styles[ecp])
    ax.set_xlim((x[0],x[-1]))

    ax.axvline(req[mol],color='black',linestyle='--',linewidth=1.5,dashes=(2,2))
    plt.legend(loc='best', ncol=2)
    
    if savefig:
        plt.savefig('mol_figs/'+mol+'.pdf')
    #end if
    if show:
        plt.show()
    #end if

for moli,mol in enumerate(mols):
    if moli==len(mols)-1:
        show=True
    else:
        show=False
    #end if
    plot(mol,savefig=True,show=show)
#end for

