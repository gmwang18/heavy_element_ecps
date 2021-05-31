#!/usr/bin/env python

import numpy as np
import sys


num_core_spinors = 10


with open('multidets.dat') as f:
    lines = f.readlines()
    det_strings = []
    weight_strings = []
    for line in lines:
#        print('lines: ', line)
        det_strings.append(line.split()[1])
        weight_strings.append(float(line.split()[-2]))


num_val_spinors = len(det_strings[0])
active_spinors = num_core_spinors + num_val_spinors

prestring = list(range(1,num_core_spinors+1))

valence_string = list(range(num_core_spinors+1,active_spinors,2))
valence_string += list(range(num_core_spinors+2,active_spinors+1,2))
print(valence_string)




for i in range(len(det_strings)):
    for j in range(len(prestring)):
        print(prestring[j], end=" ")
    for j in range(len(valence_string)):
        if det_strings[i][j] == "1":
            print(valence_string[j], end=" ")
    print()
