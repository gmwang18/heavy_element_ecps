#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

### Written by M. C. Bennett

#  Example of expected Molpro input:
# ==============================
#  s, S , 5481000.0000000, 820600.0000000, 186700.0000000, 52880.0000000, 17250.0000000, 6226.0000000, 2429.0000000, 1007.0000000, 439.5000000, 199.8000000, 93.9200000, 45.3400000, 22.1500000, 10.3400000, 5.1190000, 2.5530000, 1.2820000, 0.5450000, 0.2411000, 0.1035000, 0.0420000
#  c, 1.11, 0.0000019, 0.0000147, 0.0000775, 0.0003272, 0.0011937, 0.0038839, 0.0115336, 0.0312748, 0.0764387, 0.1627000, 0.2793280
#  c, 1.11, -0.0000005, -0.0000041, -0.0000214, -0.0000905, -0.0003301, -0.0010778, -0.0032187, -0.0088722, -0.0223771, -0.0510577, -0.1002250
#  c, 12.12, 1
#  c, 13.13, 1
#  c, 14.14, 1
#  c, 15.15, 1
#  c, 16.16, 1
#  c, 17.17, 1
#  c, 18.18, 1
#  c, 19.19, 1
#  c, 20.20, 1
#  c, 21.21, 1
#  p, S , 2200.0000000, 521.4000000, 169.0000000, 64.0500000, 26.7200000, 11.8300000, 5.3780000, 2.4820000, 1.1160000, 0.4848000, 0.2006000, 0.0795100, 0.0294000
#  c, 1.3, 0.0002390, 0.0020769, 0.0112363
#  c, 4.4, 1
#  c, 5.5, 1
#  c, 6.6, 1
#  c, 7.7, 1
#  c, 8.8, 1
#  c, 9.9, 1
#  c, 10.10, 1
#  c, 11.11, 1
#  c, 12.12, 1
#  c, 13.13, 1
#  d, S , 0.2050000, 0.5120000, 1.2810000, 3.2030000, 56.6940000, 28.0700000, 13.8980000, 6.8810000, 0.0794000
#  c, 1.1, 1
#  c, 2.2, 1
#  c, 3.3, 1
#  c, 4.4, 1
#  c, 5.5, 1
#  c, 6.6, 1
#  c, 7.7, 1
#  c, 8.8, 1
#  c, 9.9, 1
#  f, S , 0.2550000, 0.5290000, 1.0960000, 26.3820000, 11.0720000, 4.6470000, 0.1188000
#  c, 1.1, 1
#  c, 2.2, 1
#  c, 3.3, 1
#  c, 4.4, 1
#  c, 5.5, 1
#  c, 6.6, 1
#  c, 7.7, 1
#  g, S , 0.4630000, 1.0710000, 20.3460000, 7.9080000, 0.2200000
#  c, 1.1, 1
#  c, 2.2, 1
#  c, 3.3, 1
#  c, 4.4, 1
#  c, 5.5, 1
#  h, S , 0.8720000, 15.3060000, 0.4720000
#  c, 1.1, 1
#  c, 2.2, 1
#  c, 3.3, 1

def write_primitives(basis, atom):
	filename = sys.argv[1].split('.')[0]
	cardinal = sys.argv[1].split('.')[1]
	f = open(filename+"."+cardinal+".prim",'w')
	labels=['s','p','d','f','g','h','i','k']
	for c in basis:
		if len(c[1]) > 1:
			continue
		else:
			f.write('{}, {}, {:10.6f} \n'.format(labels[c[0]], atom, c[1][0]))
	f.close()

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
			f.write('{:11.7f} {:10.7f}\n'.format(c[1][i],c[2][i]))
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
	ell_labels=['s','p','d','f','g','h','i','k']
	basis = []
	f = open(sys.argv[1],"r")
	for line in f:
		# Break line into words using comma as delimiter and store in ell_list
		line = line.replace(';', '') # Get rid of semicolons
		ell_list = line.replace(' ','').replace('\n','').split(',')
		# Check if line contains a list of contraction exponents. 
		# We know it does if the first word is an angular momentum label (i.e, s, p, d,...)
		if ell_list[0] in ell_labels:
			atom = ell_list[1]
			ell_val = ell_labels.index(ell_list[0])
			cexps = ell_list[2:]
			cexps = [float(i) for i in cexps]
			if(len(cexps)==1):
				contraction=[ell_val,[cexps[0]],[1.0]]
				basis.append(contraction)
		# Check if line contains a list of contraction coefficients. We know it does if the first word is 'c'
		elif ell_list[0] == 'c' and len(cexps)!=1:
			crange = ell_list[1].split('.')
			crange = [int(i) for i in crange]
			ccoeffs = ell_list[2:]
			ccoeffs = [float(i) for i in ccoeffs]
			if (len(ccoeffs)!=(crange[1]-crange[0]+1)):
				print("Range not consistent with number of contraction coefficients. Exiting...")
				quit()
			contraction=[ell_val,cexps[crange[0]-1:crange[1]],ccoeffs]
			basis.append(contraction)

	write_nwchem(basis, atom)
	write_gamess(basis, atom)
	write_dirac(basis, atom)
	#write_primitives(basis, atom)




