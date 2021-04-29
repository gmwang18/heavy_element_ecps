#!/usr/bin/env python

import sys
import os
import glob
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import pickle

### === Define styles ===
styles={
'MAD'	:{'label':'MAD',	'color':'#ff6666','linestyle':'-', 'marker':'s', 'markersize':6, 'markeredgecolor':'#000000', 'markeredgewidth':0.5},
'LMAD'	:{'label':'LMAD',	'color':'#ff9900','linestyle':'--','dashes':(3,1), 'marker':'D', 'markersize':5, 'markeredgecolor':'#000000', 'markeredgewidth':0.5},
'WMAD'	:{'label':'WMAD',	'color':'#4d79ff','linestyle':'--','dashes':(1,1), 'marker':'o', 'markersize':6, 'markeredgecolor':'#000000', 'markeredgewidth':0.5},
}

toeV = 27.211386

### === Get the molecule names in the path ===
systems = glob.glob("*.csv")
atoms=[]
### Get rid of csv extension
for atom in systems:
	atoms.append(os.path.splitext(atom)[0])
#print(atoms)

def init():
	font   = {'family' : 'serif', 'size': 17}
	lines  = {'linewidth': 2.2}
	axes   = {'linewidth': 2.0}    # border width
	tick   = {'major.size': 2, 'major.width':2}
	legend = {'frameon':True, 'fontsize':16.0, 'handlelength':3.00, 'labelspacing':0.30, 'handletextpad':0.4, 'loc':'best', 'facecolor':'white', 'framealpha':1.00, 'edgecolor':'#f2f2f2'}
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

def get_data(atom):
	files = glob.glob(atom+'*.csv')
	if len(files) > 1:
	    print('Too many csv files for {}'.format(atom))
	    sys.exit()
	elif len(files) == 0:
	    df = pd.DataFrame()
	else:
	    df = pd.read_csv(files[0],index_col=0)
	#df.dropna(inplace=True)
	return df

def plot(atom):
	print('Atom: {}'.format(atom))
	fig, ax1 = init()
	df = get_data(atom)
	
	ax1.axhspan(0.000, 0.043, alpha=0.25, color='gray')
	ax1.axhline(0.0,linewidth=1.0,color='black')
	ax1.set_xlabel('Core Approximations')
	ax1.set_ylabel('(L)MAD [eV]')
	x = df.index.values
	y1 = df["MAD"].values
	y2 = df["LMAD"].values
	ax1.plot(x,y1,**styles["MAD"])
	ax1.plot(x,y2,**styles["LMAD"])
	plt.xticks(rotation = 25, fontsize=15)

	ax1 = plt.gca()
	ax2 = ax1.twinx()
	ax2.tick_params(direction='in', length=6, width=2, which='major', pad=5)
	ax2.tick_params(direction='in', length=4, width=1, which='minor', pad=5)
	ax2.grid(b=None, which='major', axis='both', alpha=0.0)
	ax2.set_ylabel(r'WMAD [\%]')
	y3 = df["WMAD"].values
	ax2.axhline(0.0,linewidth=0.5,color='black', alpha=0)
	ax2.plot(x,y3,**styles["WMAD"])

	lines_1, labels_1 = ax1.get_legend_handles_labels()
	lines_2, labels_2 = ax2.get_legend_handles_labels()
	
	lines = lines_1 + lines_2
	labels = labels_1 + labels_2

	ax2.legend(lines, labels, frameon=True, fontsize=16.0, handlelength=2.50, labelspacing=0.40, handletextpad=0.4, loc='best', facecolor='white', framealpha=1.0, edgecolor='#f2f2f2')
	#ax2.annotate("%s" % atom, xy=(0.05, 0.15), xycoords='axes fraction')
	#plt.legend(loc='best', ncol=1)
	plt.savefig('atom_figs/'+atom+'.pdf')
	plt.show()

for atom in atoms:
	plot(atom)

