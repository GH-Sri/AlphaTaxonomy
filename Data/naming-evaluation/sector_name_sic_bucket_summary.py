if __name__ == '__main__':
    
    for index in range(1, 11):
        
        buckets = ((1, 9),
                   (10, 14),
                   (15, 17),
                   (20, 39),
                   (40, 49),
                   (50, 51),
                   (52, 59),
                   (60, 67),
                   (70, 89),
                   (91, 99))
        
        counts = list(0 for _ in buckets)
        
        filename = 'Sector{index}-sic-freq.txt'.format(index=index) 
        with open(filename) as f:
            for line in f:
                sic, count = line.strip().split()[:2]
                
                if sic[0] != '#':
                    sic = int(sic) // 100
                    
                    countindex = None
                    
                    for bucket, bucketkey in enumerate(buckets):
                        if bucketkey[0] <= sic <= bucketkey[1]:
                            countindex = bucket
                            
                    if countindex is not None:                            
                        counts[countindex] += int(count)
    
        print ('processing {filename}'.format(filename=filename))
        total = sum(counts)
        for countindex, count in enumerate(counts):
            print ("SEC's Sector {index}: {count} ({percentage})".format(
                index=countindex, count=count, percentage=count/total))

        print ('')
  