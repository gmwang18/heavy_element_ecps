#!/usr/bin/env python

import sys
import os
import glob
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import pickle


toeV = 27.211386

### === Get the molecule names in the path ===
systems = glob.glob("*.csv")
atoms=['I', 'Te', 'Bi', 'Ag', 'Au', 'W', 'Mo', 'Ir']
### Get rid of csv extension
#print(atoms)


### === Define styles ===

linestyles_solid={
'UC'          :{'color':'#ff0000','linestyle':'-'},
'BFD'         :{'color':'#0000ff','linestyle':'-'},
'MDFSTU'      :{'color':'#ff6600','linestyle':'-'},
'MWBSTU'      :{'color':'#ff33cc','linestyle':'-'},
'CRENB(L/S)'  :{'color':'#2f4f4f','linestyle':'-'},
'SBKJC'       :{'color':'#1e90ff','linestyle':'-'},
'LANL2'       :{'color':'#a52a2a','linestyle':'-'},
'ccECP'       :{'color':'#009900','linestyle':'-'},
}

linestyles_dashed={
'UC'          :{'color':'#ff0000','linestyle':'--'},
'BFD'         :{'color':'#0000ff','linestyle':'--'},
'MDFSTU'      :{'color':'#ff6600','linestyle':'--'},
'MWBSTU'      :{'color':'#ff33cc','linestyle':'--'},
'CRENB(L/S)'  :{'color':'#2f4f4f','linestyle':'--'},
'SBKJC'       :{'color':'#1e90ff','linestyle':'--'},
'LANL2'       :{'color':'#a52a2a','linestyle':'--'},
'ccECP'       :{'color':'#009900','linestyle':'--'},
}

pointstyles = {
'UC'          :{'label':'UC',         'color':'#ff0000','marker':'.'},
'BFD'         :{'label':'BFD',        'color':'#0000ff','marker':','},
'MDFSTU'      :{'label':'MDFSTU',     'color':'#ff6600','marker':'o'},
'MWBSTU'      :{'label':'MWBSTU',     'color':'#ff33cc','marker':'x'},
'CRENB(L/S)'  :{'label':'CRENB(L/S)', 'color':'#2f4f4f','marker':'|'},
'SBKJC'       :{'label':'SBKJC',      'color':'#1e90ff','marker':'+'},
'LANL2'       :{'label':'LANL2',      'color':'#a52a2a','marker':'h'},
'ccECP'       :{'label':'ccECP',      'color':'#009900','marker':'d'},
}


pointstyles_no_label = {
'UC'          :{'color':'#ff0000','marker':'.'},
'BFD'         :{'color':'#0000ff','marker':','},
'MDFSTU'      :{'color':'#ff6600','marker':'o'},
'MWBSTU'      :{'color':'#ff33cc','marker':'x'},
'CRENB(L/S)'  :{'color':'#2f4f4f','marker':'|'},
'SBKJC'       :{'color':'#1e90ff','marker':'+'},
'LANL2'       :{'color':'#a52a2a','marker':'h'},
'ccECP'       :{'color':'#009900','marker':'d'},
}


def mpl_init():
    font   = {'family' : 'serif', 'size': 16}
    lines  = {'linewidth': 2.2}
    axes   = {'linewidth': 2.0}    # border width
    tick   = {'major.size': 2, 'major.width':2}
    legend = {'frameon':True, 'fontsize':14.0, 'handlelength':3.00, 'labelspacing':0.30, 'handletextpad':0.4, 'loc':'best', 'facecolor':'white', 'framealpha':0.25, 'edgecolor':'#f2f2f2'}
    mpl.rc('font',**font)
    mpl.rc('lines',**lines)
    mpl.rc('axes',**axes)
    mpl.rc('xtick',**tick)
    mpl.rc('ytick',**tick)
    mpl.rc('legend',**legend)
    mpl.rcParams['text.usetex'] = True
    mpl.rcParams.update({'figure.autolayout':True})
    fig = plt.figure()
    fig.set_size_inches(7.04, 5.28)   # Default 6.4, 4.8
    ax1 = fig.add_subplot(111) # row, column, nth plot
    ax1.tick_params(direction='in', length=6, width=2, which='major', pad=6)
    ax1.tick_params(direction='in', length=4, width=1, which='minor', pad=6)
    ax1.grid(b=None, which='major', axis='both', alpha=0.10)

    return fig, ax1

def get_data(atom):
    files = glob.glob(atom+'.csv')
    if len(files) > 1:
        print('Too many csv files for {}'.format(atom))
        sys.exit()
    elif len(files) == 0:
        df = pd.DataFrame()
    else:
        df = pd.read_csv(files[0],index_col=0)
    #df.dropna(inplace=True)
    return df

def initialize_df():
    new_df = pd.DataFrame(columns=atoms, index=None)
    new_df.insert(0, 'ECPs', ecps)
    new_df = new_df.set_index('ECPs')
    return new_df


def read_mads(df_elem, metric):
    res_mads = []
    for ecp in ecps:
        try:
            one_mad = df_elem.loc[ecp, metric]
            res_mads.append(one_mad)
        except:
            res_mads.append(np.nan)

    return res_mads

def plot_style1():

    fig, ax1 = mpl_init()
    iatoms = [i for i, atom in enumerate(atoms)]
    ax1.set_xlim(-0.5,len(iatoms)-0.5)
    ax1.axhline(0.00, color='black')
    ax1.axhspan(0.00,0.043,alpha=0.25,color='gray')

    for ecp in ecps:
        ax1.scatter(iatoms, df_lmad.loc[ecp], **pointstyles[ecp])
        ax1.plot(iatoms, df_lmad.loc[ecp], **linestyles_solid[ecp])
    ax1.set_xticks(iatoms)
    ax1.set_xticklabels(atoms)

    ax1.set_ylabel('LMAD (eV)')
    ax1.legend(ncol=1,loc='best',handletextpad=0.1)
    plt.savefig('atom_figs/lmad.pdf')
    plt.show()

    fig, ax2 = mpl_init()
    iatoms = [i for i, atom in enumerate(atoms)]
    ax2.set_xlim(-0.5,len(iatoms)-0.5)
    ax2.axhline(0.00, color='black')
    ax2.axhspan(0.00,0.043,alpha=0.25,color='gray')


    for ecp in ecps:
        ax2.scatter(iatoms, df_mad.loc[ecp], **pointstyles[ecp])
        ax2.plot(iatoms, df_mad.loc[ecp], **linestyles_solid[ecp])

    ax2.set_xticks(iatoms)
    ax2.set_xticklabels(atoms)

    ax2.set_ylabel('MAD (eV)')
    ax2.legend(ncol=1,loc='upper left',handletextpad=0.1)
    plt.savefig('atom_figs/mad.pdf')
    plt.show()


    fig, ax3 = mpl_init()
    iatoms = [i for i, atom in enumerate(atoms)]
    ax3.set_xlim(-0.5,len(iatoms)-0.5)
    ax3.axhline(0.00, color='black')
    ax3.axhspan(0.00,0.043,alpha=0.25,color='gray')


    for ecp in ecps:
        
        ax3.scatter(iatoms, df_wmad.loc[ecp], **pointstyles[ecp])
        ax3.plot(iatoms, df_wmad.loc[ecp], **linestyles_solid[ecp])
    ax3.set_xticks(iatoms)
    ax3.set_xticklabels(atoms)

    ax3.set_ylabel(r'WMAD [\%]')
    ax3.legend(ncol=2,loc='best',handletextpad=0.1)
    plt.savefig('atom_figs/wmad.pdf')
    plt.show()



def plot_style2():

    fig, ax1 = mpl_init()
    iatoms = [i for i, atom in enumerate(atoms)]
    ax1.set_xlim(-0.5,len(iatoms)-0.5)
    ax1.axhline(0.00, color='black')
    ax1.axhspan(0.00,0.043,alpha=0.25,color='gray')

    for ecp in ecps:
        ax1.scatter(iatoms, df_lmad.loc[ecp], **pointstyles[ecp])
        ax1.plot(iatoms, df_lmad.loc[ecp], **linestyles_solid[ecp])

        ax1.scatter(iatoms, df_mad.loc[ecp], **pointstyles_no_label[ecp])
        ax1.plot(iatoms, df_mad.loc[ecp], **linestyles_dashed[ecp])
    ax1.set_xticks(iatoms)
    ax1.set_xticklabels(atoms)

    ax1.set_ylabel('(L)MAD (eV)')
    ax1.legend(ncol=1,loc='upper left',handletextpad=0.1)
    # plt.savefig('(l)mad.pdf')
    plt.show()

    fig, ax3 = mpl_init()
    iatoms = [i for i, atom in enumerate(atoms)]
    ax3.set_xlim(-0.5,len(iatoms)-0.5)
    ax3.axhline(0.00, color='black')

    

    for ecp in ecps:
        ax3.scatter(iatoms, df_wmad.loc[ecp], **pointstyles[ecp])
        ax3.plot(iatoms, df_wmad.loc[ecp], **linestyles_solid[ecp])
        
    ax3.set_xticks(iatoms)
    ax3.set_xticklabels(atoms)

    ax3.set_ylabel(r'WMAD [\%]')
    ax3.legend(ncol=1,loc='best',handletextpad=0.1)
    # plt.savefig('(l)mad.pdf')
    plt.show()


def plot_style3():

    fig, ax1 = mpl_init()
    iatoms = [i for i, atom in enumerate(atoms)]
    ax1.set_xlim(-0.5,len(iatoms)-0.5)
    ax1.axhline(0.00, color='black')
    ax1.axhspan(0.00,0.043,alpha=0.25,color='gray')

    for ecp in ecps:
        ax1.scatter(iatoms, df_lmad.loc[ecp], **pointstyles[ecp])
        ax1.plot(iatoms, df_lmad.loc[ecp], **linestyles_solid[ecp])
    ax1.set_xticks(iatoms)
    ax1.set_xticklabels(atoms)

    ax1.set_ylabel('LMAD (eV)')
    ax1.legend(ncol=1,loc='best',handletextpad=0.1)
    # plt.savefig('(l)mad.pdf')
    plt.show()

    fig, ax2 = mpl_init()
    iatoms = [i for i, atom in enumerate(atoms)]
    ax2.set_xlim(-0.5,len(iatoms)-0.5)
    ax2.axhline(0.00, color='black')
    ax2.axhspan(0.00,0.043,alpha=0.25,color='gray')

    ax3 = ax2.twinx()

    for ecp in ecps:
        ax2.scatter(iatoms, df_mad.loc[ecp], **pointstyles[ecp])
        ax2.plot(iatoms, df_mad.loc[ecp], **linestyles_solid[ecp])
        
        ax3.scatter(iatoms, df_wmad.loc[ecp], **pointstyles_no_label[ecp])
        ax3.plot(iatoms, df_wmad.loc[ecp], **linestyles_dashed[ecp])
    ax2.set_xticks(iatoms)
    ax2.set_xticklabels(atoms)

    ax2.set_ylabel('(W)MAD (eV)')
    ax3.set_ylabel(r'WMAD [\%]')
    ax2.legend(ncol=1,loc='best',handletextpad=0.1)
    # plt.savefig('(l)mad.pdf')
    plt.show()

def initialize_data():


    df_lmad = initialize_df()
    df_mad  = initialize_df()
    df_wmad = initialize_df()
    #### Average MADs plot
    mapped_df = {'LMAD': df_lmad, 'MAD': df_mad, 'WMAD': df_wmad}


    for atom in atoms:
        df_elem = get_data(atom)
        df_elem = df_elem.rename(index={"CRENBL":"CRENB(L/S)", "CRENBS":"CRENB(L/S)"})
        for metric in metrics:
            res_mads = read_mads(df_elem, metric)
            mapped_df[metric][atom] = res_mads

    # print(df_lmad)
    # print(df_mad)
    # print(df_wmad)
    return df_lmad, df_mad, df_wmad


if __name__ == "__main__":

    ecps = ['LANL2', 'BFD', 'SBKJC', 'CRENB(L/S)', 'MWBSTU', 'MDFSTU', 'UC', 'ccECP']
    metrics = ['LMAD', 'MAD', 'WMAD']
    df_lmad, df_mad, df_wmad = initialize_data()

    if len(sys.argv) != 2:
        print('Need to provide what to plot')
        sys.exit()
    elif sys.argv[1] == 'style1':
        plot_style1()
    elif sys.argv[1] == 'style2':
        plot_style2()
    elif sys.argv[1] == 'style3':
        plot_style3()
    else:
        print('Incorrect state to plot')
        sys.exit()
