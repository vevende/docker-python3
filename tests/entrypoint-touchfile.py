import os

entryname = '/tmp/%s.txt' % os.path.basename(os.path.abspath(__file__))

with open(entryname, 'wt') as fobj:
    fobj.write('Hi!')
