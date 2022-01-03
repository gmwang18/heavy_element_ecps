import numpy as np

#f = open('qw.slater','w')
output = []
count = 0
with open('Au.jast3', 'r') as fhand:
    for line in fhand.readlines():
         if 'threebody' in line or 'THREEBODY' in line:
             count += 1
         if count > 0 and count < 4:
             count += 1
             output += [line]
fhand.close()

line_num = 0
with open('Au.opt2.wfout','r') as f:
    for line in f.readlines():
        if line.split()[0] == 'EIBASIS' or line.split()[0] == 'eibasis':
            break
        line_num += 1
f.close()


with open('Au.opt2.wfout','r') as f:
     contents = f.readlines()
f.close

#print(contents)
#print(line_num)
#print(len(output))
contents.insert(line_num,''.join(output))

#print(''.join(contents))
with open('Au.opt2.wfout','w') as f:
    contents = "".join(contents)
    f.write(contents)
f.close()

