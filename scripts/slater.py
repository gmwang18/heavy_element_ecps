#!/usr/bin/python

import numpy as np
import sys
import re

##############################################
#Get the number of NCLOSE from the input file#
def read_NCLOSE(inp):
    d_inp=open(inp, 'r')
    content=d_inp.readlines()
    txt='.CLOSED SHELL\n'
    for line_num,line in enumerate(content):
        if txt in line:
            nc_line_num = line_num+1
    nc_line = content[nc_line_num]
    NCLOSE=sum([int(i) for i in nc_line.split()])
    return NCLOSE
    d_inp.close()


###############################################
####Find the line numbers with 'det#'##########
def find_det(out):
    d_out=open(out,'r')
    content=d_out.readlines()
    txt='det#'
    det_line=[]
    for line_num,line in enumerate(content):
        if txt in line:
            det_line.append(line_num)
    d_out.close()
    return det_line[0],det_line[1]


###############################################
###Find the sections with slater information###
def find_slater(out,det_range):
    d_out=open(out,'r')
    content=d_out.readlines()
    patt=re.compile("\s{23,24}\d+\s{2}\d+\s{16}")
    new_content = list(filter(patt.match,content[det_range[0]:det_range[1]]))
    slater_block=[]
    slater_block_element=[]
    for i in range(len(new_content)-1):
        oldlines = new_content[i]
        lines = new_content[i+1]
       #print(int(oldlines.split()[0]))
        if int(lines.split()[0]) <= int(oldlines.split()[0]):
            slater_block_element.append(oldlines.split())
            slater_block.append(slater_block_element)
            slater_block_element = []
        else:
            slater_block_element.append(oldlines.split())
    return (slater_block)
    d_out.close()

###############################################
##Convert the information in slater to output##
def convert_slater(slater_block,num_of_states,NCLOSE):
    total_states = len(slater_block)
    first_slater = slater_block[0]
    active_spinor = NCLOSE + len(list(first_slater[0][1]))
    tar_slater = slater_block[num_of_states]
    occupation = []
    occupation_element=list(range(1,NCLOSE+1))
    open_occu=list(range(NCLOSE+1,active_spinor,2))
    open_occu+=list(range(NCLOSE+2,active_spinor+1,2))
    for i in tar_slater:
        occu_list = list(i[1])
        occu_dict = {open_occu[i]:occu_list[i] for i in range(len(occu_list))}
        for key,value in occu_dict.items():
            if '1' == value:
                occupation_element.append(key)
        occu_ele =str(occupation_element).replace(',',' ')
        occu_ele =str(occu_ele).replace('[',' ')
        occu_ele =str(occu_ele).replace(']',' ')
        occupation_element=list(range(1,NCLOSE+1))
        occupation.append(occu_ele)
    coeff = []
    f_coeff=[]
    for i in tar_slater:
        coeff.append(i[-2])
    if float(coeff[0]) < 0:
        f_coeff.append([-float(i) for i in coeff])
    else:
        f_coeff.append([float(i) for i in coeff])
    return occupation,f_coeff,active_spinor
################################################
#The following class will generate name.slater#
class slater:
    def __init__(self,c,o,mo,n):
        self.coeff = c
        self.occu = o
        self.nmo = mo
        self.name = n
    def prt(self):
        print('''  SPINORSLATER
  CORBITALS {{
    QUATERNION_MO
    NOSORT
    MAGNIFY 1
    NMO {}
    ORBFILE {}.orb
    INCLUDE {}.basis
    CENTERS {{ USEATOMS }}
  }}\n'''.format(self.nmo, self.name, self.name))
        for elements in self.coeff[0]:
            print('''  CSF {{    {:.4f}   1.0  }}'''.format(elements))
        print('''\n  STATES {''')
        for occupations in self.occu:
            print('''{}'''.format(occupations))
        print('''  }''')


################################################
name = input("The name of the atom:")
inp = input("The path of the dirac input file:")
out = input("The path of the dirac output file:")
num_state =input("The number of multiplets for the given state:")
################################################
NCLOSE = read_NCLOSE(inp)
det_range = find_det(out)
slater_block=find_slater(out,det_range)
for i in range(int(num_state)):
    occupation,coeff,nmo = convert_slater(slater_block,i,NCLOSE)
    s=slater(coeff,occupation,nmo,name)
    filename = "{}_state{}.slater".format(name,i+1)
    sys.stdout=open(filename,"w")
    s.prt()
    sys.stdout.close()

