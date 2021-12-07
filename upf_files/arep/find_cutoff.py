#!/usr/bin/env python

import pandas as pd

### ===== PARAMETERS =====
ecp_valence = {			# Number of electrions in the system
#"Li_reg"	:3, 
#"Be_reg"	:4, 
#"Na_Ne"	:1, 
#"Mg_Ne"	:2, 
#"Na_He"	:9, 
#"Mg_He"	:10, 
#"Al_He"	:11, 
#"Si_He"	:12, 
#"P_He"		:13,
#"S_He"		:14,
#"Cl_He"	:15,
#"Ar_He"	:16,
#"Au"		:19, 
#"I"		:7, 
#"Te"		:6, 
"W"		:14, 
}
wfc_initial = 20.0		# Don't check for wfc values (Ry) smaller than this
conv_elec_deriv = 5.0E-8	# dE/(d(wfc) * N_e) : Energy change per electron per 1 Ry wfc change. 5E-8 seems reasoanble.
meet_convergence = 10		# Number of times to meet convergence criteria. Useful against accidental numerical convergences.
### ======================

ecp_cutoffs = pd.DataFrame(columns=['ecp', 'wfc'])
ecp_cutoffs['ecp'] = ecp_valence.keys()
#print(ecp_cutoffs)

for ecp in ecp_valence.keys():
	print(ecp)
	valence = ecp_valence[ecp]
	conv_total_deriv = conv_elec_deriv * valence
	
	element_name = ecp.split('_')[0]
	df = pd.read_csv(ecp + "/" + element_name + ".kedat", delim_whitespace=True, skiprows=3)
	df.columns = ['wfc', 'x', 'ekin']
	#print(df.head())
	
	convergences = 0
	
	for index, wfc in enumerate(df['wfc']):
		if wfc < wfc_initial:	# Don't check for too small wfc values
			continue
		elif (wfc > wfc_initial and wfc < 2400):
			try:
				wfc_current = wfc
				wfc_next = df['wfc'].iloc[index+1]
				ekin_current = df['ekin'].iloc[index]
				ekin_next = df['ekin'].iloc[index+1]
				#print("Cutoffs used", wfc_current, wfc_next)
				#print("Energies used", ekin_current, ekin_next)
				deriv = abs((ekin_next - ekin_current)/(wfc_next - wfc_current))
				#print(wfc_current, deriv)
	
				### Check for convergence
				if (deriv < conv_total_deriv):
					#print("Found a convergence at index", index)
					convergences = convergences + 1	
					if convergences == meet_convergence:
						print("CONVERGENCE FOUND!")
						print("KINETIC ENERGY CUTOFF: {} {}".format(int(wfc_current), "Ry"))
						#print("KINETIC ENERGY: {:.6f}".format(ekin_current))
						ecp_cutoffs.loc[ecp_cutoffs['ecp'] == ecp, 'wfc'] = int(wfc_current)
						break
			except:
				print("Something went wrong. Perhaps not enough data to see convergence.")
		else:
			print("The wfc is getting too large. No convergence was found. Quitting.")
			break
	
print(ecp_cutoffs)


