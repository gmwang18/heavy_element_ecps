#!/usr/bin/env python3                                                                                                                                                                         

import sys
import os
import numpy as np
import pandas as pd
import string
import math
from itertools import repeat
import matplotlib as mpl
import matplotlib.pyplot as plt


import uncertainties
from uncertainties import ufloat
from uncertainties import unumpy
from uncertainties import ufloat_fromstr



def mpl_init():
    font = {'family' : 'serif',
            'size': 20}
    lines = {'linewidth':2,'markersize':8}
    axes = {'linewidth': 3}
    xtick = {'major.size': 5,
            'major.width':2}
    ytick = {'major.size': 5,
            'major.width':2,
            'minor.visible':True,
            'minor.size':3,
            'minor.width':2,
            'direction':'in'}
    legend = {'frameon':False,
              'fontsize':15,
              'handlelength':2.5}
    mpl.rc('font',**font)
    mpl.rc('lines',**lines)
    mpl.rc('axes',**axes)
    mpl.rc('xtick',**xtick)
    mpl.rc('ytick',**ytick)
    mpl.rc('legend',**legend)
    mpl.rcParams['text.usetex'] = True
    mpl.rcParams.update({'figure.autolayout':True})
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    return fig,ax1


linestyles = {
'STU'        :{'color':'#ff7f00','linestyle':'-'},
'ccECP'      :{'color':'#009900','linestyle':'-'},
}
pointstyles = {
'STU'      :{'label': 'STU',     'color':'#ff7f00','marker': 'o'},
'ccECP'    :{'label': r'ccECP',  'color':'#009900','marker': 'd'},
}


### =================== FUNCTIONS ======================

class ShorthandFormatter(string.Formatter):
	def format_field(self, value, format_spec):
		if isinstance(value, uncertainties.UFloat):
			return value.format(format_spec+'S')  # Shorthand option added
		# Special formatting for other types can be added here (floats, etc.)
		else:
			# Usual formatting:
			return super(ShorthandFormatter, self).format_field(value, format_spec)
frmtr = ShorthandFormatter()

def f2s(x, digits = 1):   # float to string
	try:
		#y = frmtr.format("{0:.1u}", x)
		y = frmtr.format("{0:."+str(digits)+"u}", x)
	except:
		y = x
	return y

def s2f(x):   # string to float
	if isinstance(x, float) or isinstance(x, int):
		y = x
	else:
		try:
			try:
				y = float(x)
			except:
				y = ufloat_fromstr(x)
		except:
			y = x
	return y

def pd_s2f(df):   # df to df with uncertainties
	udf = df.copy()
	for column in df.columns:
		try:
			udf[column] = list(map(s2f,list(df[column])))
		except:
			udf[column] = "pd_s2f failed"
	return udf

def pd_f2s(udf, digits = 1):   # df to df with uncertainties
	df = udf.copy()
	for column in udf.columns:
		try:
			#df[column] = list(map(f2s,list(udf[column])))
			df[column] = list(map(f2s,list(udf[column]), repeat(digits)))
		except:
			df[column] = "pd_f2s failed"
	return df

def pd_mad(errors):	# Handle MAD with error bars
	errors = np.mean(np.absolute(np.array(errors)))
	return errors


def pd_separate(udf_column):
	values = udf_column.values
	errors = np.zeros(len(values))
	for i, value in enumerate(values):
		try:
			values[i] = value.nominal_value
			errors[i] = value.std_devs
		except:
			errors[i] = 0
			continue
	return values, errors


### =====================================

toev = 27.211386245988
pd.options.display.float_format = "{:,.3f}".format
#elements = ["I", "Bi"]
elements = ["I", "Te", "Bi", "Au", "Ag", "W", "Mo", "Ir"]
ecps = ["STU", "ccECP"]

df_mad = pd.DataFrame()
df_mad['element'] = elements

### =======================================

stu_cosci_mad = [np.nan] * len(elements)
ccecp_cosci_mad = stu_cosci_mad.copy()
stu_ccsd_mad = stu_cosci_mad.copy()
ccecp_ccsd_mad = stu_cosci_mad.copy()
stu_mult_mad = stu_cosci_mad.copy()
ccecp_mult_mad = stu_cosci_mad.copy()
stu_all_mad = stu_cosci_mad.copy()
ccecp_all_mad = stu_cosci_mad.copy()

for i, element in enumerate(elements):
	print(element)
	df = pd.read_csv(element+".csv", delim_whitespace=True, engine='python', na_values='-')
	df = pd_s2f(df)

	for j, ecp in enumerate(ecps):
		df["COSCI/" + ecp] = df["COSCI/AE"] - df["COSCI/" + ecp] 
		df["FPSODMC/" + ecp] = df["Expt."] - df["FPSODMC/" + ecp] 
		df["FPSODMC/" + ecp] = df["FPSODMC/" + ecp][df["Expt."].notnull()]

		if element == 'I' or element == 'Bi' or element == 'Te':
			df.loc["MAD", "FPSODMC/" + ecp] = pd_mad(df[(df["Ref"] == 0) & (df["Expt."])]["FPSODMC/" + ecp].values)

			stu_all_mad[i] = df.loc["MAD", "FPSODMC/STU"]
			ccecp_all_mad[i] = df.loc["MAD", "FPSODMC/ccECP"]

			#mult_start_idx = df.index[df["Ref"] == 1][1]
			#df.loc["mult-MAD", "FPSODMC/" + ecp] = pd_mad(df[df["Ref"] == 0]["FPSODMC/" + ecp][df["Expt."].notnull()].iloc[mult_start_idx:].values)
		else:

			if any('CCSD' in column for column in df.columns):
				df["REP-CCSD(T)/" + ecp] = df["Expt."] - df["REP-CCSD(T)/" + ecp]
				df.loc["state-MAD", "REP-CCSD(T)/" + ecp] = df["REP-CCSD(T)/" + ecp].abs().mean()

				stu_ccsd_mad[i] = df.loc["state-MAD", "REP-CCSD(T)/STU"]
				ccecp_ccsd_mad[i] = df.loc["state-MAD", "REP-CCSD(T)/ccECP"]


			mult_start_idx = df.index[df["Ref"] == 1][1]
			df.loc["mult-MAD", "FPSODMC/" + ecp] = pd_mad(df[df["Ref"] == 0]["FPSODMC/" + ecp][df["Expt."].notnull()].iloc[mult_start_idx:].values)

			stu_mult_mad[i] = df.loc["mult-MAD", "FPSODMC/STU"]
			ccecp_mult_mad[i] = df.loc["mult-MAD", "FPSODMC/ccECP"]


		df.loc["MAD", "COSCI/" + ecp] = df[df["Ref"] == 0]["COSCI/" + ecp].abs().mean()



	stu_cosci_mad[i] = df.loc["MAD", "COSCI/STU"]
	ccecp_cosci_mad[i] = df.loc["MAD", "COSCI/ccECP"]
                

	
	del df["Ref"]
	df = df.fillna(' ')
	df = pd_f2s(df)
	print(df.to_latex(escape=False))


df_mad['MAD(COSCI)/STU'] = stu_cosci_mad
df_mad['MAD(COSCI)/ccECP'] = ccecp_cosci_mad

df_mad['MAD(All-states)/STU'] = stu_all_mad
df_mad['MAD(All-states)/ccECP'] = ccecp_all_mad

df_mad['MAD(J-states)/STU'] = stu_mult_mad
df_mad['MAD(J-states)/ccECP'] = ccecp_mult_mad

df_mad['MAD(CCSD)/STU'] = stu_ccsd_mad
df_mad['MAD(CCSD)/ccECP'] = ccecp_ccsd_mad


def plot_cosci_mad():

	fig, ax = mpl_init()

	ielement = [i for i, element in enumerate(elements)]
	ax.set_xlim(-0.5, len(ielement)-0.5)
	ax.axhline(0.0, color='black')
	ax.axhspan(0, 0.043, alpha=0.25, color='gray')
	for calc in ['STU', 'ccECP']:
		ax.scatter(ielement, df_mad['MAD(COSCI)/{}'.format(calc)], **pointstyles[calc])
		ax.plot(ielement, df_mad['MAD(COSCI)/{}'.format(calc)], **linestyles[calc])
	ax.set_xticks(ielement)
	ax.set_xticklabels(elements)
	ax.set_ylabel('MAD/COSCI (eV)')
	ax.set_title('ECP to AE')

	plt.legend(loc='upper left', handletextpad=0.1)
	plt.savefig('mad-COSCI.pdf')
	plt.show()


def plot_all_mad():

	fig, ax = mpl_init()

	ielement = [i for i, element in enumerate(elements)]
	ax.set_xlim(-0.5, len(ielement)-0.5)
	ax.axhline(0.0, color='black')
	ax.axhspan(0, 0.043, alpha=0.25, color='gray')
	for calc in ['STU', 'ccECP']:
		main_values, main_errors = pd_separate(df_mad['MAD(All-states)/{}'.format(calc)])
		tran_values, tran_errors = pd_separate(df_mad['MAD(J-states)/{}'.format(calc)])
		for i, v in enumerate(tran_values):
			if math.isnan(v):
				tran_values[i] = main_values[i]
				tran_errors[i] = main_errors[i]
		ax.scatter(ielement, tran_values, **pointstyles[calc])
		ax.plot(ielement, tran_values, **linestyles[calc])
		#ax.scatter(ielement, df_mad['MAD(CCSD)/{}'.format(calc)], **pointstyles[calc])
		#ax.plot(ielement, df_mad['MAD(CCSD)/{}'.format(calc)], **linestyles[calc])
	ax.set_xticks(ielement)
	ax.set_xticklabels(elements)
	ax.set_ylabel('MAD/FPSODMC (eV)')
	ax.set_title('ECP to Expt. ')

	plt.legend(loc='upper left', handletextpad=0.1)
	plt.savefig('mad-FPDMC.pdf')
	plt.show()

pd_separate(df_mad['MAD(J-states)/STU'])

plot_cosci_mad()
plot_all_mad()
