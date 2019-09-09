#! /usr/bin/env python


import matplotlib
matplotlib.use('TkAgg')
import sys,os
import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd


#os.system("module load texlive")
#os.system("module load python")

toev=27.21138602

ecps = ['UC', 'CRENBL', 'LANL2DZ', 'MHFSTU','MDFSTU','chandler-stu-mod']
styles = {
'UC'          :{'label': 'UC',       'color':'#e41a1c','linestyle':'-'},
'CRENBL'      :{'label': 'CRENBL',   'color':'#377eb8','linestyle':'-','dashes': (3,1,1,2) },
'LANL2DZ'     :{'label': 'LANL2DZ',  'color':'#ff7f00','linestyle':'--','dashes': (8,5,1,3)},
'MHFSTU'       :{'label': 'MHFSTU',    'color':'#984ea3','linestyle':'--','dashes': (6,3)     },
'MDFSTU'      :{'label': 'MDFSTU',   'color':'#DC0174','linestyle':'-','dashes': (3,1,1,2) },
#'sub0'       :{'label': 'Sub0',      'color':'#6600ff','linestyle':'--','dashes': (3,2)      },
#'smal-se3'     :{'label': 'energy3',      'color':'#006666','linestyle':'--','dashes': (4,3)     },
#'norm-bfd-0.33'     :{'label': 'Norm-bfd',      'color':'#008000','linestyle':'--','dashes': (6,6)     },
'chandler-stu-mod'      :{'label': 'stu-mod',    'color':'#008000','linestyle':'--','dashes': (4,2,1,2) },
#
#'ag9'     :{'label': 'ccECP-unpublished',      'color':'#4daf4a','linestyle':'-','dashes': (2,3)     },
}

def init():
    font = {'family' : 'serif',
            'size': 20}
    lines = {'linewidth':4}
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

def get_data():
    data = pd.DataFrame()
    df = pd.read_csv("AE/qzbind", delim_whitespace=True)
    data['r']= df['r']
    data['ae']= df['bind']
    for ecp in ecps:
        df = pd.read_csv("%s/qzbind" % ecp, delim_whitespace=True)
        data[ecp] = df['bind']
    return data

def plot():
    fig,ax = init()
    data = get_data()
    #print data.head()
    data.to_csv("SrO_qz.csv", sep=',', index=False)

    ax.axhspan(-0.05,0.05,alpha=0.25,color='gray')
    ax.axhline(0.0,color='black')
    ax.set_xlabel('Bond Length (\AA)')
    ax.set_ylabel('Discrepancy (eV)')
    for i,ecp in enumerate(ecps):
        x = data['r']
        y = (data[ecp] - data['ae'])*toev
        plt.plot(x,y,**styles[ecp])
    ax.set_xlim((1.40,2.30))
    ax.set_ylim((-0.75,0.35))
    ax.set(title='SrO qz Discrepancies')
    plt.legend(loc='best',ncol=2)
    plt.axvline(1.9379387916356698,ls='--',color='gray',linewidth=1.0)
    plt.savefig('SrO_qz.pdf')
    plt.savefig('SrO_qz.png')
    plt.show()

if __name__ == '__main__':
    plot()
