
with open('/tmp/%s.txt' % os.path.basename(os.path.abspath(__file__)), 'wt') as fobj:
    fobj.write('Hi!')
