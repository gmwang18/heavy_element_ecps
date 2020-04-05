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

ecps = ['UC', 'CRENBL', 'LANL2DZ', 'SBKJC','MDFSTU','cody-stu-mod','ag9']#'sub0','smal-se3','se3','se4']
styles = {
'UC'          :{'label': 'UC',       'color':'#e41a1c','linestyle':'-'},
'CRENBL'      :{'label': 'CRENBL',   'color':'#377eb8','linestyle':'-','dashes': (3,1,1,2) },
'LANL2DZ'     :{'label': 'LANL2DZ',  'color':'#ff7f00','linestyle':'--','dashes': (8,5,1,3)},
'SBKJC'       :{'label': 'SBKJC',    'color':'#984ea3','linestyle':'--','dashes': (6,3)     },
'MDFSTU'      :{'label': 'MDFSTU28',   'color':'#DC0174','linestyle':'-','dashes': (3,1,1,2) },
#'sub0'       :{'label': 'Sub0',      'color':'#6600ff','linestyle':'--','dashes': (3,2)      },
#'smal-se3'     :{'label': 'energy3',      'color':'#006666','linestyle':'--','dashes': (4,3)     },
#'cody-stu-mod-no-d'     :{'label': 'cody-stu-mod-no-d',      'color':'#008000','linestyle':'--','dashes': (6,6)     },
#'cody-stu-mod'      :{'label': 'cody-stu-mod',    'color':'#cc0099','linestyle':'--','dashes': (4,2,1,2) },
'cody-stu-mod'      :{'label': 'MWBSTU28-reg',    'color':'#009900','linestyle':'--','dashes': (4,2,1,2) },
#
'ag9'     :{'label': 'ccECP-0.01',      'color':'#39e600','linestyle':'-','dashes': (2,3)     },
}

def init():
    font = {'family' : 'serif',
            'size': 20}
    lines = {'linewidth':3}
    axes = {'linewidth': 3}
    tick = {'major.size': 4,
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
    df = pd.read_csv("AE/5zbind", delim_whitespace=True)
    data['r']= df['r']
    data['ae']= df['bind']
    for ecp in ecps:
        df = pd.read_csv("%s/5zbind" % ecp, delim_whitespace=True)
        data[ecp] = df['bind']
    return data

def plot():
    fig,ax = init()
    data = get_data()
    #print data.head()
    data.to_csv("AgO_5z.csv", sep=',', index=False)

    ax.axhspan(-0.05,0.05,alpha=0.25,color='gray')
    ax.axhline(0.0,color='black')
    ax.set_xlabel('Bond Length (\AA)')
    ax.set_ylabel('Discrepancy (eV)')
    for i,ecp in enumerate(ecps):
        x = data['r']
        y = (data[ecp] - data['ae'])*toev
        plt.plot(x,y,**styles[ecp])
    ax.set_xlim((1.60,2.40))
    ax.set_ylim((-0.05,0.2))
    ax.set(title='AgO 5z Discrepancies')
    plt.legend(loc='best',ncol=2,prop={'size': 15})
    plt.axvline(1.98904602337,ls='--',color='gray',linewidth=1.0)
    plt.savefig('AgO_5z.pdf')
    plt.savefig('AgO_5z.png')
    plt.show()

if __name__ == '__main__':
    plot()
