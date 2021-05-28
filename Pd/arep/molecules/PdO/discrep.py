#!/usr/bin/env python

import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd
import pickle
import sys

ecps = ['UC','MDFSTU','CRENBL','SBKJC','LANL2', 'ccECP']
styles = {
'UC'		:{'label':'UC',		'color':'#e41a1c','linestyle':'-'                  },
'MDFSTU'	:{'label':'MDFSTU',	'color':'#ff7f00','linestyle':'--','dashes': (7,2) },
'MWBSTU'	:{'label':'MWBSTU',	'color':'#9966ff','linestyle':'--','dashes': (4,2) },
'CRENBL'	:{'label':'CRENBL',	'color':'#993300','linestyle':'--','dashes': (3,2) },
'SBKJC'		:{'label':'SBKJC',	'color':'#377eb8','linestyle':'--','dashes': (16,2)}, 
'LANL2'		:{'label':'LANL2',	'color':'#b3b300','linestyle':'--','dashes': (5,5) },
'BFD'		:{'label':'BFD',	'color':'#003366','linestyle':'--','dashes': (3,3) },
'ccECP'		:{'label':'ccECP',	'color':'#009900','linestyle':'--','dashes': (3,3) },
}

Req=1.912

def init():
	font = {'family' : 'serif', 'size': 16}
	lines = {'linewidth':3.5}
	axes = {'linewidth': 3}
	tick = {'major.size': 5, 'major.width':2}
	legend = {'frameon':False, 'fontsize':16}

	mpl.rc('font',**font)
	mpl.rc('lines',**lines)
	mpl.rc('axes',**axes)
	mpl.rc('xtick',**tick)
	mpl.rc('ytick',**tick)
	mpl.rc('legend',**legend)

	mpl.rcParams['text.usetex'] = True
	mpl.rcParams.update({'figure.autolayout':True})
	fig = plt.figure()
	fig.set_size_inches(8.50, 6.50)   # Default 6.4, 4.8
	ax1 = fig.add_subplot(111)
	return fig,ax1

def get_data():
	ae = pd.read_csv('AE/bind.csv',sep=',', index_col='z')
	dfs = pd.DataFrame()
	for ecp in ecps:
		df = pd.read_csv(ecp+'/bind.csv',sep=',')
		dfs[ecp] = df['bind']
	dfs = dfs.set_index(ae.index)
	#ha = dfs.copy()
	#ha.index = ae.index
	#ha['ae'] = ae['bind']
	#ha.to_csv('BiO_TZ.csv', float_format = "%.6f")
	ae  =  ae.sort_index()
	dfs = dfs.sort_index()
	return ae,dfs

def write_data(name):
	ae = pd.read_csv('AE/bind.csv',sep=',', index_col='z')
	dfs = pd.DataFrame()
	for ecp in ecps:
		df = pd.read_csv(ecp+'/bind.csv',sep=',')
		dfs[ecp] = df['bind']
	dfs = dfs.set_index(ae.index)
	dfs['AE'] = ae['bind']
	dfs = dfs.sort_index()
	dfs.to_csv(name, float_format = "%.6f")
	return dfs


def plot(r0=None):
	fig,ax = init()
	ae,ecps = get_data()

	ax.grid(b=None, which='major', axis='both', alpha=0.1)
	ax.tick_params(direction='in', length=5.0)
	ax.axhspan(-0.043,0.043,alpha=0.25,color='gray')
	ax.axhline(0.0,color='black')
	ax.set_xlabel('Bond Length (\AA)')
	ax.set_ylabel('Discrepancy (eV)')
	for i,ecp in enumerate(ecps):
		x = ecps.index.values
		y = (ecps[ecp].values - ae['bind'].values)*27.211386
		plt.plot(x,y,**styles[ecp])
	ax.set_xlim((x[0],x[-1]))
	if r0:
		ax.axvline(r0,color='black',linestyle='--',linewidth=1.5,dashes=(2,2))
		#ax.annotate(r'All-electron $R_{\rm eq}$ ', xy=(r0, 0.45*ax.get_ylim()[1]), xytext=(1.2*r0, 0.45*ax.get_ylim()[1]),color='red',va='center',ha='center',
            	#arrowprops=dict(arrowstyle='->',color='red'),)
		#ax.annotate('Near Dissociation ',xy=(ax.get_xlim()[0],0.8*ax.get_ylim()[0]), xytext=(1.15*ax.get_xlim()[0],0.8*ax.get_ylim()[0]),color='red',va='center',ha='left',
            	#arrowprops=dict(arrowstyle='->',color='red'),)

	plt.legend(loc='best')
	#plt.savefig('discrep.pdf')
	plt.show()

if __name__ == '__main__':
	if len(sys.argv) == 2:
		plot(r0=float(sys.argv[1]))
	else:
		plot()
		write_data('PdO_TZ.csv')
