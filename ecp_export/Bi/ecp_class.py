#! /usr/bin/env python3

### Written by Cody. A. Melton
### Expanded by A. Annaberdiyev

import sys
import os
import numpy as np
import matplotlib.pyplot as plt

# A class that takes numHF ECP format as input. Useful for code format conversions using the same "pp.d" file. The style for numHF ECP should be as:
# ==============
# Zeff n_channels_AREP n_channels_SOREP
# n_terms_AREP_s n_terms_AREP_p ... n_terms_AREP_local   n_terms_SOREP_p n_terms_SOREP_d ...
# AREP_terms
# SOREP_terms
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
# If there are no SOREP terms, the corresponding sections can be omitted.


class ECP:
	def __init__(self,Zeff=0,n=None,a=None,c=None,n_so=None,a_so=None,c_so=None,label=None,element=None,core=None,L=None,L_so=None):
		self.zeff = Zeff
		self.element = element
		self.core = core
		self.L = L	# Length of AREP terms
		self.L_so = L_so	# Length of SOREP terms
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
		header = f.readline().split()
		so_terms = False
		if len(header) == 3:
			#print("ECP input with spin-orbit terms detected. Using SOREP form.")
			so_terms = True
		self.zeff = int(header[0])
		L = int(header[1])
		if so_terms == True:
			L_so = int(header[2])
		else:
			L_so = 0
		if so_terms == True:
			assert (L-L_so) == 2, "Number of AREP channels and SOREP channels seem incompatible! Please check if SOREP terms are correctly provided."
		nterms = []
		nterms_so = []
		line = f.readline().split()
		assert (L_so + L) == len(line), "Total number of AREP+SOREP terms incompatible in the header section of the ECP! Please check for consistency."
		self.L = L
		self.L_so = L_so
		for i in range(L):
			nterms.append(int(line[i]))
		for i in range(L, L_so+L):
			nterms_so.append(int(line[i]))
		for i in range(L):
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
		for i in range(L_so):
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
		n = self.n.copy()
		coeff = self.coeff.copy()
		alpha = self.alpha.copy()
		if self.L_so != 0:
			n_so = self.n_so.copy()
			coeff_so = self.coeff_so.copy()
			alpha_so = self.alpha_so.copy()
		else:
			n_so = []
		### Write Header
		f.write('{},{},{},{},{}\n'.format('ECP',self.element,str(self.core),str(len(n)-1), str(len(n_so))))
		### Write Gaussians
		n = n[-1:] + n[:-1]   # Move last item to the front
		alpha = alpha[-1:] + alpha[:-1]   # Move last item to the front
		coeff = coeff[-1:] + coeff[:-1]   # Move last item to the front
		for i in range(self.L):
			f.write('{}\n'.format(len(n[i])))
			for j in range(len(n[i])):
				f.write('{}, {:11.6f}, {:11.6f}\n'.format(n[i][j],alpha[i][j],coeff[i][j]))
		if self.L_so != 0:
			for i in range(self.L_so):
				f.write('{}\n'.format(len(n_so[i])))
				for j in range(len(n_so[i])):
					f.write('{}, {:11.6f}, {:11.6f}\n'.format(n_so[i][j],alpha_so[i][j],coeff_so[i][j]))
		f.close()

	def write_nwchem(self,filename):
		f = open(filename,'w')
		n = self.n.copy()
		alpha = self.alpha.copy()
		coeff = self.coeff.copy()
		if self.L_so != 0:
			n_so = self.n_so.copy()
			coeff_so = self.coeff_so.copy()
			alpha_so = self.alpha_so.copy()
		else:
			n_so = []
		### Write Header
		f.write('ecp\n')
		f.write('{} {} {}\n'.format(self.element,"nelec",str(self.core)))
		### Write Gaussians
		n = n[-1:] + n[:-1]   # Move last item to the front
		alpha = alpha[-1:] + alpha[:-1]   # Move last item to the front
		coeff = coeff[-1:] + coeff[:-1]   # Move last item to the front
		ell = ["ul", "s", "p", "d", "f", "g", "h", "i"]
		for i in range(self.L):
			f.write('{} {}\n'.format(self.element, ell[i]))
			for j in range(len(n[i])):
				f.write('{} {:11.6f} {:11.6f}\n'.format(n[i][j],alpha[i][j],coeff[i][j]))
		f.write('end\n\n')
		if self.L_so != 0:
			f.write('so\n')
			for i in range(self.L_so):
				f.write('{} {}\n'.format(self.element, ell[i+2]))
				for j in range(len(n_so[i])):
					f.write('{} {:11.6f} {:11.6f}\n'.format(n_so[i][j],alpha_so[i][j],coeff_so[i][j]))
			f.write('end\n')
		f.close()

	def write_gamess(self,filename):
		f = open(filename,'w')
		n = self.n.copy()
		alpha = self.alpha.copy()
		coeff = self.coeff.copy()
		### Write Header
		f.write('{} {} {} {}\n'.format(self.element+"-ccECP","GEN",str(self.core),str(len(n)-1)))
		### Write Gaussians
		n = n[-1:] + n[:-1]   # Move last item to the front
		alpha = alpha[-1:] + alpha[:-1]   # Move last item to the front
		coeff = coeff[-1:] + coeff[:-1]   # Move last item to the front
		for i in range(len(n)):
			f.write('{}\n'.format(len(n[i])))
			for j in range(len(n[i])):
				f.write('{:11.6f} {} {:11.6f}\n'.format(coeff[i][j],n[i][j],alpha[i][j]))
		f.close()

	def write_qwalk_so(self,filename):
		if self.L_so == 0:
			print("QWalk: This function is defined for SOREP only. Exiting.")
			return
		else:
			f = open(filename,'w')
			n = self.n.copy()
			alpha = self.alpha.copy()
			coeff = self.coeff.copy()
			n_so = self.n_so.copy()
			coeff_so = self.coeff_so.copy()
			alpha_so = self.alpha_so.copy()
			### Write Header
			f.write('{} {}\n'.format(0.0,str(len(n) + len(n_so))))
			for i in range(len(n)):
				if i==0 or i==len(n)-1: # ell=s or ell=local. No SOREP
					f.write('{} '.format(str(len(n[i]))))
				else:
					f.write('{} '.format(str(len(n[i])+len(n_so[i-1])))) # (ell + 1/2)
					f.write('{} '.format(str(len(n[i])+len(n_so[i-1])))) # (ell - 1/2)
			f.write('\n')
			### Write Gaussians
			for i in range(len(n)):
				if i==0 or i==len(n)-1: # ell=s or ell=local. No SOREP
					for j in range(len(n[i])):
						f.write('{} {:11.6f} {:11.6f}\n'.format(n[i][j],alpha[i][j],coeff[i][j]))
				else:
					for j in range(len(n[i])): # Unchanged AREP part for (ell + 1/2)
						f.write('{} {:11.6f} {:11.6f}\n'.format(n[i][j],alpha[i][j],coeff[i][j]))
					for k in range(len(n_so[i-1])): # SOREP contribution to (ell + 1/2)
						f.write('{} {:11.6f} {:11.6f}\n'.format(n_so[i-1][k],alpha_so[i-1][k],(i/2)*coeff_so[i-1][k]))
					for j in range(len(n[i])): # Unchanged AREP part for (ell - 1/2)
						f.write('{} {:11.6f} {:11.6f}\n'.format(n[i][j],alpha[i][j],coeff[i][j]))
					for k in range(len(n_so[i-1])): # SOREP contribution to (ell - 1/2)
						f.write('{} {:11.6f} {:11.6f}\n'.format(n_so[i-1][k],alpha_so[i-1][k],(-(i+1)/2)*coeff_so[i-1][k]))
			f.close()

	def write_dirac(self,filename):
		f = open(filename,'w')
		n = self.n.copy()
		alpha = self.alpha.copy()
		coeff = self.coeff.copy()
		if self.L_so != 0:
			n_so = self.n_so.copy()
			coeff_so = self.coeff_so.copy()
			alpha_so = self.alpha_so.copy()
		else:
			n_so = []
		### Write Header
		f.write('{} {} {} {}\n'.format('ECP',str(self.core),str(len(n)),str(len(n_so))))
		ell = ["$LOCAL", "$S", "$P", "$D", "$F", "$G", "$H", "$I"]
		### Write AREP Gaussians
		n = n[-1:] + n[:-1]   # Move last item to the front
		alpha = alpha[-1:] + alpha[:-1]   # Move last item to the front
		coeff = coeff[-1:] + coeff[:-1]   # Move last item to the front
		for i in range(len(n)):
			f.write('{}\n'.format(ell[i]))
			f.write('{}\n'.format(len(n[i])))
			for j in range(len(n[i])):
				f.write('{} {:11.6f} {:11.6f}\n'.format(n[i][j],alpha[i][j],coeff[i][j]))
		### Write SOREP Gaussians
		if self.L_so != 0:
			f.write("$SPIN-ORBIT\n")
			for i in range(len(n_so)):
				f.write('{}\n'.format(ell[i+2]))
				f.write('{}\n'.format(len(n_so[i])))
				for j in range(len(n_so[i])):
					f.write('{} {:11.6f} {:11.6f}\n'.format(n_so[i][j],alpha_so[i][j],coeff_so[i][j]))
		f.close()

	def write_manuscript(self,filename):
		f = open(filename,'w')
		n = self.n.copy()
		alpha = self.alpha.copy()
		coeff = self.coeff.copy()
		if self.L_so != 0:
			n_so = self.n_so.copy()
			coeff_so = self.coeff_so.copy()
			alpha_so = self.alpha_so.copy()
		else:
			n_so = []
		ell = [0, 1, 2, 3, 4, 5, 6]
		### Write AREP Gaussians
		for i in range(len(n)):
			for j in range(len(n[i])):
				f.write('{} & {} & {:11.6f} & {:11.6f}\n'.format(ell[i],n[i][j],alpha[i][j],coeff[i][j]))
		f.write('  &   &             &            \n')
		### Write SOREP Gaussians
		if self.L_so != 0:
			for i in range(len(n_so)):
				for j in range(len(n_so[i])):
					f.write('{} & {} & {:11.6f} & {:11.6f}\n'.format(ell[i+2],n_so[i][j],alpha_so[i][j],coeff_so[i][j]))
		f.close()

### End of class defintion

my_ecp = ECP(element = "Bi", core = 78)
my_ecp.read_ecp_so('pp.d')

my_ecp.write_molpro('Bi.ccECP.molpro')
my_ecp.write_nwchem('Bi.ccECP.nwchem')
my_ecp.write_gamess('Bi.ccECP.gamess')
my_ecp.write_dirac('Bi.ccECP.dirac')
my_ecp.write_qwalk_so('Bi.ccECP.qwalk')
my_ecp.write_manuscript('Bi.ccECP.man')

