#!/usr/bin/env python3                                                                                                                                                                         

import sys
import os
import numpy as np
import pandas as pd
import string
from itertools import repeat

import uncertainties
from uncertainties import ufloat
from uncertainties import unumpy
from uncertainties import ufloat_fromstr

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

### =====================================

toev = 27.211386245988
pd.options.display.float_format = "{:,.3f}".format
#elements = ["I", "Bi"]
elements = ["I", "Bi", "Au", "Ag"]
ecps = ["STU", "ccECP"]

### =======================================

for element in elements:
	print(element)
	df = pd.read_csv(element+".csv", delim_whitespace=True, engine='python', na_values='-')
	df = pd_s2f(df)

	for ecp in ecps:
		df["COSCI/" + ecp] = df["COSCI/AE"] - df["COSCI/" + ecp] 
		df["FPSODMC/" + ecp] = df["Expt."] - df["FPSODMC/" + ecp] 
		df["FPSODMC/" + ecp] = df["FPSODMC/" + ecp][df["Expt."].notnull()]

		if element == 'I' and element == 'Bi':
			df.loc["MAD", "FPSODMC/" + ecp] = pd_mad(df[df["Ref"] == 0]["FPSODMC/" + ecp].values)
		else:

			if any('CCSD' in column for column in df.columns):
				df["REP-CCSD(T)/" + ecp] = df["Expt."] - df["REP-CCSD(T)/" + ecp]
				df.loc["state-MAD", "REP-CCSD(T)/" + ecp] = df["REP-CCSD(T)/" + ecp].abs().mean()
			mult_start_idx = df.index[df["Ref"] == 1][1]
			df.loc["mult-MAD", "FPSODMC/" + ecp] = pd_mad(df[df["Ref"] == 0]["FPSODMC/" + ecp][df["Expt."].notnull()].iloc[mult_start_idx:].values)


		df.loc["MAD", "COSCI/" + ecp] = df[df["Ref"] == 0]["COSCI/" + ecp].abs().mean()

	
	del df["Ref"]
	df = df.fillna(' ')
	df = pd_f2s(df)
	print(df.to_latex(escape=False))
