#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

### Written by M. C. Bennett
### Expanded by A. Annaberdiyev

### Structure of the data is a list where each element is [ell, exponents, coefficients]

def write_nwchem(basis, atom):
	filename = sys.argv[1].split('.')[0]
	cardinal = sys.argv[1].split('.')[1]
	f = open(filename+"."+cardinal+".nwchem",'w')
	labels=['S','P','D','F','G','H','I','K']
	for c in basis:
		f.write('{} {}\n'.format(atom, labels[c[0]]))
		for i in range(len(c[1])):
			f.write('{:14.6f} {:10.6f}\n'.format(c[1][i],c[2][i]))
	f.close()

def write_dirac(basis, atom):
	filename = sys.argv[1].split('.')[0]
	cardinal = sys.argv[1].split('.')[1]
	f = open(filename+"."+cardinal+".dirac",'w')
	ell_lengths = np.zeros(basis[-1][0]+1, dtype=np.int8) # Assumes last element is highest L function
	for i in range(len(basis)):
		index = basis[i][0]
		ell_lengths[index] = ell_lengths[index] + 1
	labels=['s','p','d','f','g','h','i','k']
	f.write('LARGE EXPLICIT {} {}\n'.format(basis[-1][0]+1, str(ell_lengths).replace('[','').replace(']','')))
	for c in basis:
		f.write('{} {} {}\n'.format('#', labels[c[0]], 'functions'))
		f.write('{}  {}  {}\n'.format('f', len(c[1]), 1))
		for i in range(len(c[1])):
			f.write('{:15.7f} {:10.7f}\n'.format(c[1][i],c[2][i]))
	f.close()

def write_gamess(basis, atom):
	filename = sys.argv[1].split('.')[0]
	cardinal = sys.argv[1].split('.')[1]
	f = open(filename+"."+cardinal+".gamess",'w')
	labels=['S','P','D','F','G','H','I','K']
	for c in basis:
		f.write('{} {}\n'.format(labels[c[0]],len(c[1])))
		for i in range(len(c[1])):
			f.write('{:2d} {:14.6f} {:10.6f}\n'.format(i+1,c[1][i],c[2][i]))
	f.close()

if __name__ == "__main__":

	if len(sys.argv) < 2:
		print("Give a file as an argement such as Cl.cc-pVDZ")
		quit()

	ell_labels=['s','p','d','f','g','h','i','k']
	basis = []	# This is where we will store data
	f = open(sys.argv[1],"r")
	flag_exponents = 0	# This flag is 1 if exponents were read in last line

	for index, line in enumerate(f):

		# Get rid of semicolons, whitespaces, newlines
		# Break line into words using comma as delimiter and store in this_line
		this_line = line.replace(';', '').replace(' ','').replace('\n','').split(',') 

		# Check if this line is an empty line (or any other single character)
		if len(this_line) == 1:
			continue

		# Check if line contains a list of contraction exponents. 
		# We know it does if the first word is an angular momentum label (i.e, s, p, d,...)
		elif this_line[0] in ell_labels:
			if flag_exponents == 1:	# Check if previous exponents were uncontracted
				for i in range(len(cexps)):
					contraction = [ell_val,[cexps[i]],[1.0]]
					basis.append(contraction)

			atom = this_line[1]
			ell_val = ell_labels.index(this_line[0])
			cexps = this_line[2:]
			cexps = [float(i) for i in cexps]
			flag_exponents = 1

		# Check if line contains a list of contraction coefficients. We know it does if the first word is 'c'
		elif this_line[0] == 'c':
			crange = this_line[1].split('.')
			crange = [int(i) for i in crange]
			ccoeffs = this_line[2:]
			ccoeffs = [float(i) for i in ccoeffs]
			if (len(ccoeffs)!=(crange[1]-crange[0]+1)):
				print("Range not consistent with number of contraction coefficients. Exiting...")
				quit()
			if (len(cexps)!=len(ccoeffs)):	# The contractions did not fully cover all exponents
				print("WARNING: Contraction size {} is not equal to exponent list size {}. Make sure this is intended!".format(len(ccoeffs), len(cexps)))

			contraction = [ell_val,cexps[crange[0]-1:crange[1]],ccoeffs]
			basis.append(contraction)
			flag_exponents = 0
		else:
			print("Unrecognized symbol. Please check your file.")
			quit()
		
	# Check if there are any remaining uncontracted basis sets
	if flag_exponents == 1:	# Check if previous exponents were uncontracted
		for i in range(len(cexps)):
			contraction = [ell_val,[cexps[i]],[1.0]]
			basis.append(contraction)

	write_nwchem(basis, atom)
	write_gamess(basis, atom)
	write_dirac(basis, atom)

