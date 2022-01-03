#!/usr/bin/env python

import numpy as np
import sys


num_core_spinors = 8


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



ordered_list = []

for i in range(len(weight_strings)):
    ordered_list.append((weight_strings[i], [det_strings[i]]))

ordered_list = sorted(ordered_list, key=lambda k: abs(k[0]), reverse=True)


weight_strings = []
det_strings = []

for i in range(len(ordered_list)):
    weight_strings.append(ordered_list[i][0])
    det_strings.append(ordered_list[i][1][0])



for i in range(len(det_strings)):
    for j in range(len(prestring)):
        print(prestring[j], end=" ")
    for j in range(len(valence_string)):
        if det_strings[i][j] == "1":
            print(valence_string[j], end=" ")
    print()




sign = 1

if weight_strings[0] < 0:
    sign = -1
for i in range(len(weight_strings)):
    s_weight = weight_strings[i]*sign
    if s_weight > 0:
        print('',"{:.4f}".format(s_weight))
    else:
        print("{:.4f}".format(s_weight))


