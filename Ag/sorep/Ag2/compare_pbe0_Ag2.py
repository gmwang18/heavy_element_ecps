#!/usr/bin/env python3

import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import uncertainties
from uncertainties import ufloat
from uncertainties import unumpy
from uncertainties import umath
from uncertainties import ufloat_fromstr
import string
from scipy.optimize import curve_fit


toev = 27.211386245988
#np.set_printoptions(formatter={'float': '{: 0.2f}'.format})

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

def f2s(x):   # float to string
    try:
        y = frmtr.format("{0:.1u}", x)
    except:
        y = x
    return y

def s2f(x):   # string to float
    try:
        y = ufloat_fromstr(x)
    except:
        y = x
    return y


def pd_s2f(df):   # df to df with uncertainties
    udf = pd.DataFrame(columns=df.columns)
    for column in df.columns:
        #print(column)
        try:
            udf[column] = list(map(s2f,list(df[column])))
        except:
            udf[column] = "pd_s2f failed"
    return udf

def pd_f2s(udf):   # df to df with uncertainties
    df = pd.DataFrame(columns=udf.columns)
    for column in udf.columns:
        #print(column)
        try:
            df[column] = list(map(f2s,list(udf[column])))
        except:
            df[column] = "pd_f2s failed"
    return df

def init():
    font = {'family' : 'serif', 'size': 15}
    lines = {'linewidth':1.50}
    axes = {'linewidth': 3}
    tick = {'major.size': 2, 'major.width':2}
    legend = {'frameon':False, 'fontsize':13.0, 'handlelength':1.80, 'labelspacing':0.15, 'handletextpad':0.20}

    mpl.rc('font',**font)
    mpl.rc('lines',**lines)
    mpl.rc('axes',**axes)
    mpl.rc('xtick',**tick)
    mpl.rc('ytick',**tick)
    mpl.rc('legend',**legend)

    mpl.rcParams['text.usetex'] = True
    mpl.rcParams.update({'figure.autolayout':True})
    mpl.rcParams.update({'errorbar.capsize': 1})
    fig = plt.figure()
    fig.set_size_inches(7.00, 5.00)   # Default 6.4, 4.8
    ax1 = fig.add_subplot(111)
    return fig,ax1

def raw2unc(rawfile):
    df = pd.read_csv(rawfile, delim_whitespace=True, index_col=False, engine='python') #sep='\s*&\s*',
    #print(df.to_latex())
    mydf = pd.DataFrame(columns=['energy','state'])
    energy = list(df['energy'])
    error = list(df['error'])
    #print(energy)
    unc_en = []
    for i in range(len(energy)):
        unc_en.append(ufloat(energy[i],error[i]))
    #print(unc_en)
    mydf['state'] = list(df['state'])
    mydf['energy'] = unc_en
    mydf = mydf.set_index('state')
    return mydf

def morse(x,D,a,re):
        y=D*(np.exp(-2*a*(x-re))-2*np.exp(-a*(x-re)))
        return y
umorse=uncertainties.wrap(morse)

def omega(D,a,mu):
        y=umath.sqrt(2*(a**2)*D/mu)
        return y

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#df_binding = pd.DataFrame(columns=['Z'])

df_binding = pd.DataFrame()

df_cc = pd.read_csv("ccsd-t-arep-mdfstu/qz.csv", index_col=False, engine='python', sep='\s*,\s*')

print(df_cc)

bind_cc = df_cc['BIND']
bind_cc = bind_cc.values
df_binding['Z'] = df_cc['Z']
df_binding['CC'] = bind_cc

df_pbe0dmc = raw2unc('FPSODMC/pbe0-mdfstu/raw_opt.dat')
atom_pbe0dmc = ufloat(-146.9381103, 0.0007327914073)
df_binding['PBE0DMC'] = df_pbe0dmc['energy'].values - 2.0*atom_pbe0dmc

print(df_pbe0dmc)

df_cc_ccECP = pd.read_csv("ccsd-t-arep-ccECP/qz.csv", index_col=False, engine='python', sep='\s*,\s*')
bind_cc_ccECP = df_cc_ccECP['BIND']
bind_cc_ccECP = bind_cc_ccECP.values
df_binding['CC-so-ccECP'] = bind_cc_ccECP

df_ccECP_pbe0dmc = raw2unc('FPSODMC/pbe0-so-ccECP/raw_opt.dat')
atom_ccECP_pbe0dmc = ufloat(-146.9218445, 0.000546270773)
df_binding['ccECP_PBE0DMC'] = df_ccECP_pbe0dmc['energy'].values - 2.0*atom_ccECP_pbe0dmc


print(df_binding)

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

m1 = 107.87
m2 = 107.87
bohr=0.52917721067        # Bohr to Angs
amu=1822.888486                # amu to au
tocm=2.194746313702e5
mu=m1*m2/(m1+m2)
wconv=tocm*bohr/np.sqrt(amu)

styles = {
'CC'           :{'label':'UCCSD(T)/RHF (AREP-MDFSTU)', 'color':'#984ea3', 'fmt':'s',                                   'markersize':6, 'markeredgecolor':'#000000', 'markeredgewidth':0.2},
'CC_fit'       :{                               'color':'#984ea3',               'linestyle':'--','dashes': (8,2),                                                                },
'PBE0DMC'     :{'label':'FPSODMC/PBE0 (REP-MDFSTU)', 'color':'#984ea3', 'fmt':'o',                                   'markersize':6, 'markeredgecolor':'#000000', 'markeredgewidth':0.2},
'PBE0DMC_fit' :{                               'color':'#984ea3',               'linestyle':'--','dashes': (1,1),                                                                },
'CC-so-ccECP'           :{'label':'UCCSD(T)/RHF (AREP-ccECP)', 'color':'#339933', 'fmt':'.',                                   'markersize':6, 'markeredgecolor':'#000000', 'markeredgewidth':0.2},
'CC-so-ccECP_fit'       :{                               'color':'#339933',               'linestyle':'--','dashes': (8,2),                                                                },
'ccECP_PBE0DMC'     :{'label':'FPSODMC/PBE0 (REP-so-ccECP)', 'color':'#339933', 'fmt':'*',                                   'markersize':6, 'markeredgecolor':'#000000', 'markeredgewidth':0.2},
'ccECP_PBE0DMC_fit' :{                               'color':'#339933',               'linestyle':'--','dashes': (1,1),                                                                },
        }

blatex=pd.DataFrame(columns=df_binding.columns,  index=["$D_e$(eV)", "$r_e$(\AA)", "$\omega_e$(cm$^{-1}$)"])
del blatex['Z']

fig, ax = init()
ax.grid(b=None, which='major', axis='both', alpha=0.1)
ax.set_xlabel('Bond length [\AA]')
ax.set_ylabel('Binding energy $-D_e$ [eV]')
De_exp = -1.66
ax.axhline(De_exp, color='r', linestyle='-', linewidth=0.7, label='Exper. $-D_{e}$')
ax.axvline(2.6549, color='r', linestyle='-', linewidth=0.7, label='Exper. $r_{eq}$')
ax.axvline(2.48, color='r', linestyle='-', linewidth=0.7)
ax.axvline(2.53350, color='r', linestyle='-', linewidth=0.7)

for column in df_binding:
        if column == "Z":
                continue
        elif column == "CCSDT_SO":
                xdata = df_binding['Z'].values
                ydata = unumpy.nominal_values(list(df_binding[column]))
                ax.errorbar(xdata, ydata*toev, **styles[column])
        else:
                print(column)
                initial=[-0.06, 2.00, 2.6]  # initial guess
                print(initial)
#                initial=[df_binding['CC'].iloc[3], 2.00, df_binding['Z'].iloc[3]]  # initial guess
                xdata = df_binding['Z'].values
                ydata = unumpy.nominal_values(list(df_binding[column]))
                yerr = unumpy.std_devs(list(df_binding[column]))
                if column=='CC' or 'CC-so-ccECP' or 'ccECP_PBE0DMC':
                        yerr = yerr + 1.000
                popt_m, pcov_m = curve_fit(morse, xdata, ydata, sigma=yerr, p0=initial)
                #popt_m, pcov_m = curve_fit(morse, xdata, ydata, sigma=yerr)
                std=np.sqrt(np.diag(pcov_m))
                if column == 'PBE0DMC':
                    stu_dmc_bind_geo = popt_m[2]
                if column == 'CC':
                    stu_cc_bind_geo = popt_m[2]
                if column == 'ccECP_PBE0DMC':
                    ccecp_dmc_bind_geo = popt_m[2]
                if column == 'CC-so-ccECP':
                    ccecp_cc_bind_geo = popt_m[2]
                print("popt_m:", popt_m)
                print("STD:", std)
                D=ufloat(popt_m[0], std[0])
                #print(D)
                a=ufloat(popt_m[1], std[1])
                #print(a)
                re=ufloat(popt_m[2], std[2])
                #print(re)
                w=omega(D,a,mu)
                #print(w)

                blatex[column].iloc[0]=frmtr.format("{0:.1u}", D*toev)
                blatex[column].iloc[1]=frmtr.format("{0:.1u}", re)
                blatex[column].iloc[2]=frmtr.format("{0:.1u}", w*wconv)

                ax.errorbar(xdata, ydata*toev, **styles[column])
                x=np.linspace(xdata[0]-0.04, xdata[-1]+0.1, 100)
                y=morse(x, *popt_m)
                ax.plot(x, y*toev, **styles[column+'_fit'])
                
ax.axvline(stu_dmc_bind_geo, color='#984ea3', linestyle='--', linewidth=0.7, dashes=(4,4), label='MDFSTU. $r_{eq}$')
ax.axvline(ccecp_dmc_bind_geo, color='#339933', linestyle='--', linewidth=0.7, dashes=(4,4), label='so-ccECP. $r_{eq}$')
ax.axvline(stu_cc_bind_geo, color='#984ea3', linestyle='-', linewidth=0.7, label='MDFSTU. $r_{eq}$')
ax.axvline(ccecp_cc_bind_geo, color='#339933', linestyle='-', linewidth=0.7, label='so-ccECP. $r_{eq}$')
#ax.legend(loc='best', prop={'size': 12})
ax.legend(loc='upper right', prop={'size': 10.5})
ax.tick_params(direction='in', length=6.0)
plt.savefig('Ag2_PBE0_compare_binding.pdf')
plt.savefig('Ag2_PBE0_compare_binding.png', dpi=800)
#plt.show()


blatex.insert(loc=0, column='Exp.', value=0)
blatex=blatex.transpose()
print(blatex.to_latex(escape=False))
