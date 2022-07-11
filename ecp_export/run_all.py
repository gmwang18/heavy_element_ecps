#! /usr/bin/env python3

from ecp_class import *

ecp_list = {'Bi':78, 'Te':46, 'I':46, 'Mo':28, 'W':60, 'Ir':60, 'Pd':28, 'Ag':28, 'Au':60}

for ecp in ecp_list:
    os.chdir(ecp)

    my_ecp = ECP(element = ecp, core = ecp_list[ecp])
    my_ecp.read_ecp_so('pp.d')
    
    my_ecp.write_molpro(ecp+ '.ccECP.molpro')
    my_ecp.write_nwchem(ecp+ '.ccECP.nwchem')
    my_ecp.write_gamess(ecp+ '.ccECP.gamess')
    my_ecp.write_dirac(ecp+ '.ccECP.dirac')
    my_ecp.write_qwalk_so(ecp+ '.ccECP.qwalk')
    my_ecp.write_manuscript(ecp+ '.ccECP.man')

    os.chdir('../')
