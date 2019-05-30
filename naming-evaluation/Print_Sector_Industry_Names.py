import sys

if __name__ == '__main__':
    
    prefix = sys.argv[2]

    totals = {'Industry': 100,
              'Sector': 10}
    
    names = {}
    with open(sys.argv[1], mode='r') as namefile:
        
        for line in namefile:
            sic, _, name = line.strip().split(maxsplit=2)
            names[int(sic)] = name
    
    for index in range(1, totals[prefix] + 1):
        print ('{index},'.format(index=index), end='')
        with open('{prefix}{index}-sic-freq.txt'.format(
                    prefix=prefix, index=index),
                mode='r') as freqfile:
            linecount = -1

            for line in freqfile:
                if linecount < 0:
                    linecount = 0
                elif linecount >= int(sys.argv[3]):
                    break
                else:
                    linecount += 1
                    sic = int(line.strip().split()[0])
                    print ('"{name}"'.format(index=linecount,
                                                   name=names[sic]),
                                             end=',')
        print ('')