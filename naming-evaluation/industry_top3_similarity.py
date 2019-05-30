import sys
import csv
from nltk.metrics.distance import edit_distance

if __name__ == '__main__':

    counts = {}

    with open(sys.argv[1], 'r') as industryfile:
        csvreader = csv.reader(industryfile)
        for line in csvreader:
            if len(line) > 3 and line[3]:
                distances = [(edit_distance(line[1], line[2]), line[1], line[2]),
                             (edit_distance(line[2], line[3]), line[2], line[3]),
                             (edit_distance(line[1], line[3]), line[1], line[3])]
            else:
                distances = [(0, line[1], line[2])]

            distances.sort()
            names = "{industry1} and {industry2}".format(
                    id=line[0], industry1=distances[0][1],
                    industry2=distances[0][2])

            count = counts.get(names, 0)
            if count:
                print('{id},"{names}({count})"'.format(id=line[0],
                                                      names=names,
                                                      count=count))
            else:
                print('{id},"{names}"'.format(id=line[0], names=names,
                                             count=count))

            counts[names] = count + 1
