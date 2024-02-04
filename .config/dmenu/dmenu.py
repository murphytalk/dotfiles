#!/usr/bin/python2
"""
1)reads key-value pairs from TAB sperated file
2)return value corresponded to the specified key to stdout

parameters:

 dbfile name
 key

"""
import re
import sys

MATCH=re.compile(r"^([^ ]+)[ \t]+(.+)$")

def launch(dbfile,key):
    lookup  = {} #lookup dict

    #load key-value pairs from file
    lines = open(dbfile)
    for l in lines:
        if l[0]<>"#":
            m = MATCH.match(l)
            if m is not None:
                lookup[m.group(1)] = m.group(2) # key->value

    if lookup.has_key(key):
        return lookup[key]
    else:
        return key

if __name__=="__main__":
    if len(sys.argv)==3:
        cmd = launch(sys.argv[1],sys.argv[2])
        if cmd is not None:
            print cmd
