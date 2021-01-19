import sys,os
import numpy as np
from scipy.optimize import curve_fit
import matplotlib as mpl
import matplotlib.pyplot as plt

np.set_printoptions(formatter={'float': '{: 0.6f}'.format})

def f1(x, e1, c1):
        y=c1*np.exp(-e1*x**2)
        return y

def f2(x, e1, c1, e2, c2):
        y=c1*np.exp(-e1*x**2)+c2*np.exp(-e2*x**2)
        return y

def fn(x, *params):
        y=0
        for i in range(0, len(params),2):
            y=y+params[i+1]*np.exp(-params[i]*x**2)
        return y

N=20000	#grid
xdata=np.linspace(0.0, 1.5 ,N)
ydata=np.zeros(N)

ecp1=[
3.994989,  12.045915,
3.048288,  20.376657,
]

ecp2=[
3.895122,  12.075313,
2.846070,  20.397377,
]


for i in range(0, N):
	ydata[i]=0.6*fn(xdata[i],*ecp1)+0.4*fn(xdata[i],*ecp2)
#print(ydata)

initial=[
3.994989,  12.045915,
3.048288,  20.376657,
]
#initial=[1, -1]
#limit=([1.10,-np.inf, 1.10,-np.inf],[np.inf,np.inf, np.inf,np.inf])
#limit=([4.0,0.0],[np.inf,np.inf])
popt, pcov = curve_fit(f2, xdata, ydata, p0=initial) #,bounds=limit)
print('Optimal parameters:', popt)
print('One standard deviation errors on the parameters:', np.sqrt(np.diag(pcov)) )
#print('Covariance: \n', pcov)

fitdata=np.zeros(N)
ecp1_data=np.zeros(N)
ecp2_data=np.zeros(N)
for i in range(0, N):
        fitdata[i]=fn(xdata[i], *popt)
        ecp1_data[i]=fn(xdata[i], *ecp1)
        ecp2_data[i]=fn(xdata[i], *ecp2)

fig1, ax1 = plt.subplots()
plt.plot(xdata, ecp1_data, 'g--', label='ecp 1')
plt.plot(xdata, ecp2_data, 'y--', label='ecp 2')
plt.plot(xdata, ydata, 'k--', label='original data')
plt.plot(xdata, fitdata, 'r-', label='fit data')
legend = ax1.legend(loc='best', shadow=False)
plt.show()


