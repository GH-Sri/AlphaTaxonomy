import sys

if __name__ == '__main__':
    
    prefix = sys.argv[1]

    totals = {'Industry': 100,
              'Sector': 10}
    
    for index in range(1, totals[prefix] + 1):
        
        print ("Index {index}".format(index=index))
        counts = {}
        
        with open('{prefix}{index}-company-list.txt'.format(
                    prefix=prefix, index=index),
                mode='r') as listfile:
            for line in listfile:
                sic = int(line.split()[-1])

                if sic:
                    counts[sic] = counts.get(sic, 0) + 1
        
        siclist = list((count, sic) for sic, count in counts.items())
        siclist.sort(reverse=True)
        
        totalcount = sum(count for count, sic in siclist)
        
        with open('{prefix}{index}-sic-freq.txt'.format(prefix=prefix,
                                                        index=index),
                                                        mode='w') as f:
            f.write('#SIC #Occurrence #Percentage #Accumulated_Percentage\n')
            accumu_prec = 0            
            for count, sic in siclist:
                percentage = count/totalcount
                accumu_prec += percentage  
                f.write('{sic} {freq} {percentage} {accumu_prec}\n'.format(
                    sic=sic, freq=count, percentage=percentage,
                    accumu_prec=accumu_prec))
