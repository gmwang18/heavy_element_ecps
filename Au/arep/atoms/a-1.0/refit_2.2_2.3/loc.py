import sys,os
import numpy as np
from scipy.optimize import curve_fit
import matplotlib as mpl
import matplotlib.pyplot as plt

np.set_printoptions(formatter={'float': '{: 0.6f}'.format})

def f2(x, a, b):
	Zeff=19.000
	y=-Zeff/x*(1-np.exp(-a*x**2)) + a*Zeff*x*np.exp(-b*x**2)
	return y


N=50000	#grid
xdata=np.linspace(1e-10,5.0,N)
ydata=np.zeros(N)

ecp1=[
16.050466,
15.892289,

]
ecp2=[
16.094518,
15.891266,

]

for i in range(0, N):
	ydata[i]=0.6*f2(xdata[i], *ecp1)+0.4*f2(xdata[i], *ecp2)
#print ydata

initial=[16.05, 15.89]
#exp_low=1.0
#limit=([exp_low, exp_low, exp_low,-500, exp_low,-500,],[500,500,500,500,500,500])
popt, pcov = curve_fit(f2, xdata, ydata, p0=initial) #,bounds=limit)
print('Optimal parameters:', popt)
print('One standard deviation errors on the parameters:', np.sqrt(np.diag(pcov)))
#print 'Covariance: \n', pcov

fitdata=np.zeros(N)
ecp1_data=np.zeros(N)
ecp2_data=np.zeros(N)
for i in range(0, N):
        fitdata[i]=f2(xdata[i], *popt)
        ecp1_data[i]=f2(xdata[i], *ecp1)
        ecp2_data[i]=f2(xdata[i], *ecp2)


fig1, ax1 = plt.subplots()
plt.plot(xdata, ecp1_data, 'g--', label='ecp 1')
plt.plot(xdata, ecp2_data, 'y--', label='ecp 2')
plt.plot(xdata, fitdata, 'r-', label='fit data')
plt.plot(xdata, ydata, 'k--', label='original data')
legend = ax1.legend(loc='best', shadow=False)
plt.show()


