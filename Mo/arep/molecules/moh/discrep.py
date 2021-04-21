#! /usr/bin/env python

import matplotlib
matplotlib.use('TkAgg')
import sys,os
import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd


os.system("module load texlive")
os.system("module load python")

toev=27.21138602

ecps = [ 'crenbl', 'lanl2tz', 'mdfstu','uc','mwbstu','ccECP']#,'uc','sbkjc','w2', 'w3', 'w6', 'w9']#,'i0','i7', 'i6']#'sub0','smal-se3','se3','se4']
styles = {
'uc'        :{'label': 'UC',       'color':'#e41a1c','linestyle':'-'},
'crenbl'    :{'label': 'CRENBL','color':'#ff7f00','linestyle':'--','dashes': (8,5,1,3)},
'lanl2tz'   :{'label': 'LANL2TZ',    'color':'#377eb8','linestyle':'-','dashes': (3,1,1,2) },
'mdfstu'    :{'label': 'MDFSTU',      'color':'#984ea3','linestyle':'--','dashes': (6,3)     },
#'ECP2.0'     :{'label': 'ECP2.0',    'color':'#DC0174','linestyle':'-','dashes': (3,1,1,2) },
#'ECP2.1'       :{'label': 'ECP2.1',      'color':'#6600ff','linestyle':'--','dashes': (3,2)      },
'mwbstu'     :{'label': 'MWBSTU',      'color':'#006666','linestyle':'--','dashes': (4,3)     },
#
'ccECP'     :{'label': 'ccECP',      'color':'#008000','linestyle':'--','dashes': (6,6)     },
#'regstu'      :{'label': 'regstu',    'color':'#00FFFF','linestyle':'--','dashes': (4,2,1,2) },
#'regmwb'      :{'label': 'regmwb',    'color':'#cc0099','linestyle':'--','dashes': (4,2,1,2) },
#'ECP4.0'      :{'label': 'ECP4.0',    'color':'#39e600','linestyle':'--','dashes': (4,2,1,2) },
#'ECP2.4test'     :{'label': 'ECP2.4test',      'color':'#4daf4a','linestyle':'-','dashes': (2,3)     },
#'ECP3.0'      :{'label': 'ECP3.0',    'color':'#cc0099','linestyle':'--','dashes': (4,2,1,2) },

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

def get_data():
    data = pd.DataFrame()
    df = pd.read_csv("ae/tzbind", delim_whitespace=True)
    data['r']= df['r']
    data['ae']= df['bind']
    for ecp in ecps:
        df = pd.read_csv("%s/tzbind" % ecp, delim_whitespace=True)
        data[ecp] = df['bind']
    return data

def plot():
    fig,ax = init()
    data = get_data()
    #print data.head()
    data.to_csv("MoH_TZ.csv", sep=',', index=False)

    ax.axhspan(-0.05,0.05,alpha=0.25,color='gray')
    ax.axhline(0.0,color='black')
    ax.set_xlabel('Bond Length (\AA)')
    ax.set_ylabel('Discrepancy (eV)')
    for i,ecp in enumerate(ecps):
        x = data['r']
        y = (data[ecp] - data['ae'])*toev
        plt.plot(x,y,**styles[ecp])
    ax.set_xlim((1.72,2.52))
#    ax.set_ylim((-0.25,0.25))
    ax.set(title='MoH tz Discrepancies')
    #plt.legend(bbox_to_anchor=(0.53, 0.15, 0.5, 0.5), fontsize="x-small")
    plt.legend(loc='best',ncol=2,prop={'size': 15})
    plt.axvline(2.12,ls='--',color='gray',linewidth=1.0)
    plt.savefig('MoH_TZ.pdf')
    plt.show()

if __name__ == '__main__':
    plot()