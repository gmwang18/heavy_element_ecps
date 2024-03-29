#! /usr/bin/env python

### Written by Cody. A. Melton
### Expanded by A. Annaberdiyev

import sys
import os
import numpy as np
import matplotlib.pyplot as plt

# A class that takes numHF ECP format as input. Useful for code format conversions using the same "pp.d" file. The style for numHF ECP should be as:
# ==============
# Zeff n_channels_AREP n_channels_SOC
# n_terms_AREP_s n_terms_AREP_p ... n_terms_AREP_local   n_terms_SOC_p n_terms_SOC_d ...
# AREP_terms
# SOC_terms
# ==============
# An example "pp.d" file for Bi:
# ==============
# 5 5 3                              
# 3 3 3 3 4   3 3 3
# 2  3.3985625  137.0729140
# 2  2.2363910  34.3916416
# 4  1.0636817  -1.8019312
# 2  1.2456199  39.8269678
# 2  0.3667618  0.8447335
# 4  0.8237604  -4.3918552
# 2  0.9246278  -3.7879179
# 2  0.8350341  24.0963136
# 4  1.2398550  0.4563745
# 2  1.8474456  -0.3829618
# 2  1.0698424  -0.5464445
# 4  0.8621929  -0.2367081
# 1  8.0291604  5.0000000
# 3  7.4815510  40.1458018
# 2  1.7756833  -6.2512149
# 2  0.6980853  -0.2864101
# 2  3.62419551 -0.05680288
# 2  2.08401707 3.65950697
# 4  1.27996161 3.06903534
# 2  1.11843551 -4.02503595
# 2  1.87735261 3.94247322
# 4  1.00237438 -0.27672935
# 2  1.01337747 1.74543289
# 2  0.95943686 -1.64544080
# 4  1.00489490 0.00755595
# ==============
# If there are no SOC terms, the corresponding sections can be omitted.


class ECP:
	def __init__(self,Zeff=0,n=None,a=None,c=None,n_so=None,a_so=None,c_so=None,label=None,element=None,core=None):
		self.zeff = Zeff
		self.element = element
		self.core = core
		if n == None:
			self.n = []
		else:
			self.n = n
		if a == None:
			self.alpha = []
		else:
			self.alpha = a
		if c == None:
			self.coeff = []
		else:
			self.coeff = c
		if n_so == None:
			self.n_so = []
		else:
			self.n_so = n_so
		if a_so == None:
			self.alpha_so = []
		else:
			self.alpha_so = a_so
		if c_so == None:
			self.coeff_so = []
		else:
			self.coeff_so = c_so
		if label == None:
			self.label = 'ecp'
		else:
			self.label = label
	def read_ecp(self,filename):
		f=open(filename,'r')
		z,n = f.readline().split()[0:2]
		self.zeff = int(z)
		n = int(n)
		nterms = []
		line = f.readline().split()
		for i in range(n):
			nterms.append(int(line[i]))
		for i in range(n):
			N=[]
			A=[]
			C=[]
			for j in range(nterms[i]):
				line=f.readline().split()
				n = int(line[0])
				a = float(line[1])
				c = float(line[2])
				N.append(n)
				A.append(a)
				C.append(c)
			self.n.append(N)
			self.alpha.append(A)
			self.coeff.append(C)
		f.close()
	def read_ecp_so(self,filename):
		f=open(filename,'r')
		z,n,n_so = f.readline().split()
		self.zeff = int(z)
		n = int(n)
		n_so = int(n_so)
		nterms = []
		nterms_so = []
		assert (n-n_so) == 2, "It seems there are not enough SOC terms!"
		line = f.readline().split()
		for i in range(n):
			nterms.append(int(line[i]))
		for i in range(n, n_so+n):
			nterms_so.append(int(line[i]))
		for i in range(n):
			N=[]
			A=[]
			C=[]
			for j in range(nterms[i]):
				line=f.readline().split()
				n = int(line[0])
				a = float(line[1])
				c = float(line[2])
				N.append(n)
				A.append(a)
				C.append(c)
			self.n.append(N)
			self.alpha.append(A)
			self.coeff.append(C)
		for i in range(n_so):
			N_so=[]
			A_so=[]
			C_so=[]
			for j in range(nterms_so[i]):
				line=f.readline().split()
				n_so = int(line[0])
				a_so = float(line[1])
				c_so = float(line[2])
				N_so.append(n_so)
				A_so.append(a_so)
				C_so.append(c_so)
			self.n_so.append(N_so)
			self.alpha_so.append(A_so)
			self.coeff_so.append(C_so)
		f.close()
	def print_ecp(self):
		print('Zeff: {}'.format(self.zeff))
		print('n: {}'.format(self.n))
		print('alpha: {}'.format(self.alpha))
		print('coeff: {}'.format(self.coeff))
	def print_ecp_so(self):
		print('Zeff: {}'.format(self.zeff))
		print('n: {}'.format(self.n))
		print('alpha: {}'.format(self.alpha))
		print('coeff: {}'.format(self.coeff))
		print('n_so: {}'.format(self.n_so))
		print('alpha_so: {}'.format(self.alpha_so))
		print('coeff_so: {}'.format(self.coeff_so))
	def write_ecp(self,filename):
		f = open(filename,'w')
		f.write('{} {}\n'.format(self.zeff,len(self.n)))
		for i in range(len(self.n)):
			f.write('{} '.format(len(self.n[i])))
		f.write('\n')
		for i in range(len(self.n)):
			for j in range(len(self.n[i])):
				f.write('{} {} {}'.format(self.n[i][j],self.alpha[i][j],self.coeff[i][j]))
				f.write('\n')
		f.close()
	def plot_ecp(self,rmax):
		import matplotlib.pyplot as plt
		npts=100
		x = np.linspace(0.001,rmax,npts)
		for l in range(len(self.n)-1):
			y = [ self.eval_channel(l,x[i]) for i in range(npts) ]
			plt.plot(x,y,label='l = '+str(l))
		y = [ self.eval_local(x[i]) for i in range(npts) ]
		plt.plot(x,y,label='local')
		plt.legend(frameon=False)
		plt.show()
	def plot_density(self,rmax):
		import matplotlib.pyplot as plt
		npts=100
		x = np.linspace(0.001,rmax,npts)
		y = [ self.get_density(x[i]) for i in range(npts) ]
		plt.plot(x,y)
		plt.show()
	def eval_channel(self,l,r):
		n = np.array(self.n[l])
		a = np.array(self.alpha[l])
		c = np.array(self.coeff[l])
		tmp = c*r**(n-2)*np.exp(-a*r**2)
		return tmp.sum()
	def eval_local(self,r):
		tmp = self.eval_channel(-1,r)
		return tmp - self.zeff/r
	def eval_channel_lap(self,l,r):
		n = np.array(self.n[l])
		a = np.array(self.alpha[l])
		c = np.array(self.coeff[l])
		tmp = c*np.exp(-a*r**2)*r**(n-4)*(2.-3.*n+n**2+2.*a*(1.-2.*n)*r**2+4.*a**2*r**4)
		return tmp.sum()
	def get_density(self,r):
		return -0.25/np.pi*self.eval_channel_lap(-1,r)
	
	def write_molpro(self,filename):
		f = open(filename,'w')
		### Write Header
		f.write('{},{},{},{},{}\n'.format('ECP',self.element,str(self.core),str(len(self.n)-1),'0'))
		### Write Gaussians
		n = self.n  # A pointer to self.n
		n = n.insert(0, n.pop()) # Move last item to the front
		alpha = self.alpha
		alpha = alpha.insert(0, alpha.pop())
		coeff = self.coeff
		coeff = coeff.insert(0, coeff.pop())
		for i in range(len(self.n)):
			f.write('{}\n'.format(len(self.n[i])))
			for j in range(len(self.n[i])):
				f.write('{}, {:0.6f}, {:0.6f}\n'.format(self.n[i][j],self.alpha[i][j],self.coeff[i][j]))
		f.close()

	def write_qwalk(self,filename):
		f = open(filename,'w')
		### Write Header
		f.write('{} {}\n'.format(0.0,str(len(self.n) + len(self.n_so))))
		for i in range(len(self.n)):
			if i==0 or i==len(self.n)-1: # ell=s or ell=local. No SOC
				f.write('{} '.format(str(len(self.n[i]))))
			else:
				f.write('{} '.format(str(len(self.n[i])+len(self.n_so[i-1])))) # (ell + 1/2)
				f.write('{} '.format(str(len(self.n[i])+len(self.n_so[i-1])))) # (ell - 1/2)
		f.write('\n')
		### Write Gaussians
		for i in range(len(self.n)):
			if i==0 or i==len(self.n)-1: # ell=s or ell=local. No SOC
				for j in range(len(self.n[i])):
					f.write('{} {:0.6f} {:0.6f}\n'.format(self.n[i][j],self.alpha[i][j],self.coeff[i][j]))
			else:
				for j in range(len(self.n[i])): # Unchanged AREP part for (ell + 1/2)
					f.write('{} {:0.6f} {:0.6f}\n'.format(self.n[i][j],self.alpha[i][j],self.coeff[i][j]))
				for k in range(len(self.n_so[i-1])): # SOC contribution to (ell + 1/2)
					f.write('{} {:0.6f} {:0.6f}\n'.format(self.n_so[i-1][k],self.alpha_so[i-1][k],(i/2)*self.coeff_so[i-1][k]))
				for j in range(len(self.n[i])): # Unchanged AREP part for (ell - 1/2)
					f.write('{} {:0.6f} {:0.6f}\n'.format(self.n[i][j],self.alpha[i][j],self.coeff[i][j]))
				for k in range(len(self.n_so[i-1])): # SOC contribution to (ell - 1/2)
					f.write('{} {:0.6f} {:0.6f}\n'.format(self.n_so[i-1][k],self.alpha_so[i-1][k],(-(i+1)/2)*self.coeff_so[i-1][k]))
		f.close()

	def write_dirac(self,filename):
		f = open(filename,'w')
		### Write Header
		f.write('{} {} {} {}\n'.format('ECP',str(self.core),str(len(self.n)),str(len(self.n_so))))
		ell = ["$LOCAL", "$S", "$P", "$D", "$F", "$G", "$H", "$I"]
		### Write AREP Gaussians
		n = self.n  # A pointer to self.n
		n = n.insert(0, n.pop()) # Move last item to the front
		alpha = self.alpha
		alpha = alpha.insert(0, alpha.pop())
		coeff = self.coeff
		coeff = coeff.insert(0, coeff.pop())
		for i in range(len(self.n)):
			f.write('{}\n'.format(ell[i]))
			f.write('{}\n'.format(len(self.n[i])))
			for j in range(len(self.n[i])):
				f.write('{} {:0.6f} {:0.6f}\n'.format(self.n[i][j],self.alpha[i][j],self.coeff[i][j]))
		### Write SOC Gaussians
		f.write("$SPIN-ORBIT\n")
		for i in range(len(self.n_so)):
			f.write('{}\n'.format(ell[i+2]))
			f.write('{}\n'.format(len(self.n_so[i])))
			for j in range(len(self.n_so[i])):
				f.write('{} {:0.6f} {:0.6f}\n'.format(self.n_so[i][j],self.alpha_so[i][j],self.coeff_so[i][j]))
		f.close()
### End of class defintion

# ### Molpro
# my_ecp = ECP(element='Bi',core=78)
# my_ecp.read_ecp('pp.d')
# my_ecp.write_molpro('ecp.molpro')
# os.system('cat ecp.molpro')
# print("\n")
# 
# #### Dirac
# my_ecp = ECP(element='Bi',core=78)
# my_ecp.read_ecp_so('pp.d')
# my_ecp.write_dirac('ecp.dirac')
# os.system('cat ecp.dirac')
# print("\n")

#### SO-QWalk
my_ecp = ECP(element='Mo',core=46)
my_ecp.read_ecp_so('pp.d')
my_ecp.write_qwalk('ecp.qwalk')
os.system('cat ecp.qwalk')
print("\n")

