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
    font = {'family' : 'serif', 'size': 16}
    lines = {'linewidth':2.0}
    axes = {'linewidth': 2.0}
    tick = {'major.size': 2, 'major.width':2}
    legend = {'frameon':True, 'fontsize':14, 'handlelength':2.30, 'labelspacing':0.30, 'handletextpad':0.5, 'loc':'best', 'facecolor':'white', 'framealpha':1.00, 'edgecolor':'#f2f2f2'}

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
    fig.set_size_inches(7.17, 5.38)   # Default 6.4, 4.8
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

df_binding = pd.DataFrame(columns=['Z'])

df_cc = pd.read_csv("ccsd-t_arep_stu/I2/5z.csv", index_col=False, engine='python', sep='\s*,\s*')
bind_cc = df_cc['CCSD'] - df_cc['A_CCSD'].iloc[0] - df_cc['B_CCSD'].iloc[0]
bind_cc = bind_cc.values
df_binding['Z'] = df_cc['Z']
df_binding['CC'] = bind_cc

df_coscidmc = raw2unc('so_dmc/molecule/i2/stu/raw_opt.dat')
atom_coscidmc = ufloat(-11.36700536, 0.0001918225539)
df_binding['COSCIDMC'] = df_coscidmc['energy'].values - 2.0*atom_coscidmc

df_cc_ccECP = pd.read_csv("ccsd-t_arep_so_ccECP/I2/5z.csv", index_col=False, engine='python', sep='\s*,\s*')
bind_cc_ccECP = df_cc_ccECP['CCSD'] - df_cc_ccECP['A_CCSD'].iloc[0] - df_cc_ccECP['B_CCSD'].iloc[0]
bind_cc_ccECP = bind_cc_ccECP.values
df_binding['CC-so-ccECP'] = bind_cc_ccECP

df_ccECP_coscidmc = raw2unc('so_dmc/molecule/i2/so-ccECP-i8-cosci/raw_opt.dat')
atom_ccECP_coscidmc = ufloat(-11.39894683, 0.0007000684994)
df_binding['ccECP_COSCIDMC'] = df_ccECP_coscidmc['energy'].values - 2.0*atom_ccECP_coscidmc


print(df_binding)

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

m1 = 126.90447
m2 = 126.90447
bohr=0.52917721067        # Bohr to Angs
amu=1822.888486                # amu to au
tocm=2.194746313702e5
mu=m1*m2/(m1+m2)
wconv=tocm*bohr/np.sqrt(amu)

styles = {
'CC'			:{'label':'UCCSD(T)/RHF (AREP-MDFSTU)',  'color':'#984ea3', 'fmt':'s',                                   'markersize':5, 'markeredgecolor':'#000000', 'markeredgewidth':0.1},
'CC_fit'		:{					 'color':'#984ea3',               'linestyle':'--','dashes': (1,1),                                                                },
'COSCIDMC'		:{'label':'FPSODMC/COSCI (SOREP-MDFSTU)','color':'#984ea3', 'fmt':'o',                                   'markersize':5, 'markeredgecolor':'#000000', 'markeredgewidth':0.1},
'COSCIDMC_fit'		:{					 'color':'#984ea3',               'linestyle':'--','dashes': (1,1),                                                                },
'CC-so-ccECP'		:{'label':'UCCSD(T)/RHF (AREP-ccECP)',	 'color':'#339933', 'fmt':'v',                                   'markersize':6, 'markeredgecolor':'#000000', 'markeredgewidth':0.1},
'CC-so-ccECP_fit'	:{					 'color':'#339933',               'linestyle':'--','dashes': (8,2),                                                                },
'ccECP_COSCIDMC'	:{'label':'FPSODMC/COSCI (SOREP-ccECP)', 'color':'#339933', 'fmt':'^',                                   'markersize':6, 'markeredgecolor':'#000000', 'markeredgewidth':0.1},
'ccECP_COSCIDMC_fit'	:{					 'color':'#339933',               'linestyle':'--','dashes': (8,2),                                                                },
        }

blatex=pd.DataFrame(columns=df_binding.columns,  index=["$D_e$(eV)", "$r_e$(\AA)", "$\omega_e$(cm$^{-1}$)"])
del blatex['Z']

fig, ax = init()
ax.grid(b=None, which='major', axis='both', alpha=0.1)
ax.set_xlabel('Bond length [\AA]')
ax.set_ylabel('Binding energy $-D_e$ [eV]')
De_exp = -(1.54238 + 0.0132167)
ax.axhline(De_exp, color='r', linestyle='--', linewidth=1.5, label='Expt. $-D_{e}$')
ax.axvline(2.6655, color='r', linestyle='-',  linewidth=1.5, label='Expt. $r_{eq}$')

for column in df_binding:
        if column == "Z":
                continue
        elif column == "CCSDT_SO":
                xdata = df_binding['Z'].values
                ydata = unumpy.nominal_values(list(df_binding[column]))
                ax.errorbar(xdata, ydata*toev, **styles[column])
        else:
                print(column)
                initial=[df_binding['CC'].iloc[3], 2.00, df_binding['Z'].iloc[3]]  # initial guess
                xdata = df_binding['Z'].values
                ydata = unumpy.nominal_values(list(df_binding[column]))
                yerr = unumpy.std_devs(list(df_binding[column]))
                if column=='CC' or 'CC-so-ccECP' or 'ccECP_COSCIDMC':
                        yerr = yerr + 1.000
                popt_m, pcov_m = curve_fit(morse, xdata, ydata, sigma=yerr, p0=initial)
                std=np.sqrt(np.diag(pcov_m))
                if column == 'COSCIDMC':
                    stu_bind_geo = popt_m[2]
                if column == 'ccECP_COSCIDMC':
                    ccecp_bind_geo = popt_m[2]
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
                
ax.axvline(stu_bind_geo, color='#984ea3', linestyle='--', linewidth=1.5, dashes=(2,2), label='MDFSTU $r_{eq}$')
ax.axvline(ccecp_bind_geo, color='#339933', linestyle='--', linewidth=1.5, dashes=(8,2), label='ccECP $r_{eq}$')
ax.legend(loc='best')
#ax.legend(loc='upper right', prop={'size': 10.5})
ax.tick_params(direction='in', length=6.0)
plt.savefig('I2_compare_binding.pdf')
#plt.savefig('I2_compare_binding.png', dpi=800)
#plt.show()


blatex.insert(loc=0, column='Exp.', value=0)
blatex=blatex.transpose()
print(blatex.to_latex(escape=False))
