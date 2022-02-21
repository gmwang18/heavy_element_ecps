#!/usr/bin/env python3

import os
import sys
import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import uncertainties
from uncertainties import ufloat
import string
from scipy.optimize import curve_fit

##~~~~~~~~ Input ~~~~~~~~~~~~
pd.options.display.float_format = '{:,.6f}'.format	# Display format
basis = np.array([2,3,4,5])	# What basis set cardinals are used
card1=2		# First cardinal to use in extrapolation
card2=5		# Last cardinal to use in extrapolation
##~~~~~~~~~~~~~~~~~~~~~~~~~~~

def scf_cbs(n, e_cbs, c, d):	#SCF
        y = e_cbs + c*np.exp(-d*n)
        return y

def corr_cbs(n, e_cbs, c, d):	#Correlation
        y = e_cbs + c/(n+3.0/8.0)**3.0 + d/(n+3.0/8.0)**5.0
        return y

class ShorthandFormatter(string.Formatter):
    def format_field(self, value, format_spec):
        if isinstance(value, uncertainties.UFloat):
            return value.format(format_spec+'S')  # Shorthand option added
        # Special formatting for other types can be added here (floats, etc.)
        else:
            # Usual formatting:
            return super(ShorthandFormatter, self).format_field(
                value, format_spec)
frmtr = ShorthandFormatter()

### Collect the data
raw_data = pd.DataFrame(columns=basis)
for i in basis:
	myfile = os.path.join(str(i) + ".csv")
	df = pd.read_csv(myfile, sep='\s*,\s*', engine='python')	# \s*,\s* gets rid of empty spaces in column names
	raw_data.loc["SCF", i]=df['SCF'].iloc[0]
	raw_data.loc["COR", i]=df['POSTHF'].iloc[0] - df['SCF'].iloc[0]

selected_data = raw_data.loc[:, card1:card2]	# Select the desired range

####~~~~~~~~~~~ SCF Extrapolation ~~~~~~~~~~~~~~~~~~~~
ydata = np.array(selected_data.loc["SCF",:])
xdata = np.array(selected_data.columns)

initial=[min(ydata), 0.01, 1.0]
limit=([-np.inf, 0.00, 0.00], [min(ydata), np.inf, np.inf])
popt_scf, pcov_scf = curve_fit(scf_cbs, xdata, ydata, p0=initial, bounds=limit)
std_scf = np.sqrt(np.diag(pcov_scf))[0]
#print("SCF", popt_scf, std_scf)
if str(std_scf) == "inf":
	my_scf = popt_scf[0]
	raw_data.loc['SCF', 'CBS'] = my_scf
else:
	my_scf = ufloat(popt_scf[0], std_scf)
	raw_data.loc['SCF', 'CBS'] = frmtr.format("{0:.1u}", my_scf)

x=np.linspace(xdata[0],xdata[-1],50)
fig, ax = plt.subplots()
plt.plot(xdata, ydata, 'o')
plt.plot(x, scf_cbs(x, *popt_scf), '--', lw=1, label="Fitted Function")
plt.axhline(y=popt_scf[0], ls='dashed', lw=1, color='red', label='CBS limit')
ax.set(title='SCF Extrapolation Fit',
xlabel='Cardinal n',
ylabel='E(hartree)')
legend = ax.legend(loc='best', shadow=False)
##plt.savefig('extrap_scf.df', format='pdf')
plt.show()
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

####~~~~~~~~~~~ COR Extrapolation ~~~~~~~~~~~~~~~~~~~~
ydata = np.array(selected_data.loc["COR",:])
xdata = np.array(selected_data.columns)

initial=[min(ydata), 1.0, 1.0]
limit=([-np.inf, -np.inf, -np.inf], [min(ydata), np.inf, np.inf])
popt_cor, pcov_cor = curve_fit(corr_cbs, xdata, ydata, p0=initial, bounds=limit)
std_cor = np.sqrt(np.diag(pcov_cor))[0]
#print("COR", popt_cor, std_cor)
if str(std_cor) == "inf":
	my_cor = popt_cor[0]
	raw_data.loc['COR', 'CBS'] = my_cor
else:
	my_cor = ufloat(popt_cor[0], std_cor)
	raw_data.loc['COR', 'CBS'] = frmtr.format("{0:.1u}", my_cor)

x=np.linspace(xdata[0],xdata[-1],50)
fig, ax = plt.subplots()
plt.plot(xdata, ydata, 'o')
plt.plot(x, corr_cbs(x, *popt_cor), '--', lw=1, label="Fitted Function")
plt.axhline(y=popt_cor[0], ls='dashed', lw=1, color='red', label='CBS limit')
ax.set(title='COR Extrapolation Fit',
xlabel='Cardinal n',
ylabel='E(hartree)')
legend = ax.legend(loc='best', shadow=False)
##plt.savefig('extrap_cor.df', format='pdf')
plt.show()
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

print(raw_data.to_latex(na_rep=""))

