#!/usr/bin/python
import sys
lines = ['load "' + sys.argv[1] + '"']
reiterate = True
while reiterate:
    reiterate = False
    newlines = [];
    for line in lines:
        if line[:6] == 'load "':
            with open(line[6:].strip()[:-1], 'r') as reader:
                newlines.extend(reader.readlines())
            reiterate = True    
        else:
            newlines.append(line)
    lines = newlines
for line in lines:
    print(line.rstrip("\n"))
