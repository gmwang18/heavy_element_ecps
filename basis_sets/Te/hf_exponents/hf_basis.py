#! /usr/bin/env python

import os
import sys
import numpy as np
from pyscf import scf, gto
from scipy.optimize import minimize

np.set_printoptions(formatter={'float': '{: 0.6f}'.format})   # Set print detail
cwd = os.getcwd()   # Set the current working directory

atom = "Te"   # Element name
ecpfile = "ecp.nwchem"   # File containing the ECP
basfile = "basis.nwchem"  # Name of file to write the basis

N = 10   # Number of primitives in a contraction

params = np.array([   # These are the parameters we are optimizing
0.06,   # Smallest s exponent
2.10,   # Ration between s exponents

0.06,   # Smallest p exponent
2.10,   # Ration between p exponents
])

def generate_primitives(params):   # Generate primitives and write to file
	s_exp=[]
	p_exp=[]
	for i in range(0,N):
		s_exp.insert(0, params[0]*params[1]**i)
		p_exp.insert(0, params[2]*params[3]**i)
	
	f = open("basis.nwchem", 'w')
	for i in s_exp:
		f.write('{} {}\n'.format(atom, "s"))
		f.write('{:0.6f} {}\n'.format(i, "1.000"))
	for i in p_exp:
		f.write('{} {}\n'.format(atom, "p"))
		f.write('{:0.6f} {}\n'.format(i, "1.000"))
	f.close()
#generate_primitives(params)

def molpro_primitives(params):   # Generate Molpro type primitives and write to file
	s_exp=[]
	p_exp=[]
	for i in range(0,N):
		s_exp.insert(0, params[0]*params[1]**i)
		p_exp.insert(0, params[2]*params[3]**i)
	
	f = open("basis.molpro", 'w')

	f.write('{}, {}, '.format("s", atom))
	for i in s_exp:
		f.write('{:0.6f}, '.format(i))
	f.write('\n')

	f.write('{}, {}, '.format("p", atom))
	for i in p_exp:
		f.write('{:0.6f}, '.format(i))
	f.write('\n')

	f.close()
molpro_primitives(params)

def run_hf(params):   # Ruh HF using the ECP and basis files
	generate_primitives(params)
	mol = gto.Mole()
	mol.atom = "{0} 0.0 0.0 0.0".format(atom)
	with open(os.path.join(cwd,basfile)) as f:
	    bas = f.read()
	mol.basis = {atom: gto.basis.parse(bas)} 
	with open(os.path.join(cwd,ecpfile)) as f:
	    ecp = f.read()
	mol.ecp = {atom: gto.basis.parse_ecp(ecp)}
	mol.spin = 2   # Set the correct spin (2S)
	mol.charge = 0
	mol.symmetry = 'D2h'
	mol.build()
	#~~~Run HF on molecule~~~~
	hf = scf.ROHF(mol)
	hf.irrep_nelec = {
	'Ag' : (1,1),   # s    
	'B3u': (1,1),   # x    1
	'B1u': (1,0),   # z    0
	'B2u': (1,0),   # y   -1
	#'B2g': (0,0),   # xz   1
	#'B3g': (0,0),   # yz  -1
	#'B1g': (0,0),   # xy  -2
	#'Au' : (0,0)    # xyz  
	}
	hf.verbose=2
	hf.max_cycle=100
	en = hf.kernel()
	#print(params)
	return en, hf
#run_hf(params)

def hf_energy(params):   # Wrapper to run_hf to get only the energy
	en, hf = run_hf(params)
	return en

##### ~~~~ Minimize the energy ~~~~

en_initial = hf_energy(params)  # Initial energy for comparison

x0=list(params)  # Initial parameters
eps_list=[1e-3,1e-4,1e-5]  # Step sizes in optimization to be used

# We would like to put some boundaries to the parameters 
# so that they don't go to unreasonable values
limit=(   
(0.05, 0.20),   # Smallest s exponent (min, max)
(2.00, 2.50),   # Ratio of s (min, max)
(0.04, 0.20),   # Smallest p exponent (min, max)
(2.00, 2.50),   # Ratio of p (min, max)
)
#print(len(limit))

# Start with large and go to smaller step sizes for better optimization
for i in eps_list:   
	print('\n')
	print("Optimizing with step size:", i)
	res = minimize(hf_energy, x0, method='SLSQP', bounds=limit,
	                options={
				'ftol': 1e-7, 
				'disp': True, 
				'maxiter' : 10,
				'eps': i
				})
	x0=list(res.x)	# Take current params as a new initial guess

xf=list(res.x)
print(res)

en_final = hf_energy(list(res.x))   # Final energy

print('\n')
print("GAIN IN ENERGY:", en_final - en_initial)
print("FINAL ENERGY:", en_final)
print("FINAL PARAMETERS:", xf)

molpro_primitives(list(res.x))

