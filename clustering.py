# -*- coding: utf-8 -*-
"""
Created on Fri May 17 11:55:34 2019

@author: echo001
"""

"""
The following script reads the output of doc2vec and creates clusters
"""

import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster, maxdists,ward
from scipy.spatial.distance import pdist
import csv

data = []
labelList=[]
with open("C:/Users/echo001/Documents/Bids and Proposals/USCIS/cikVectorsExample1.csv", 'r') as csvfile:
    reader = csv.reader(csvfile)
    next(reader, None)  # skip the headers
    for row in reader:
        labelList.append(row[0:1])
        data.append([float(val) for val in row[2:]])
        

len(np.unique(labelList))

linked = linkage(data, 'ward',optimal_ordering=True)

dist = pdist(data)
linked = ward(dist)
plt.figure(figsize=(35, 50)) 
dendrogram(linked,  
            orientation='right',
            leaf_font_size=12.,
            labels=labelList,
            show_leaf_counts=True,
            color_threshold=maxdists(linked)[::-1][9]
            )
plt.show()

# we want to output 
# function labels each instance as cluster #
def get_n_clusters(Z, n):
    threshold=maxdists(Z)[::-1][n-1]
    return fcluster(Z,t=threshold,criterion='distance')

output=[]
sector=get_n_clusters(linked,10)
industry=get_n_clusters(linked,100)
for i in range(0,len(labelList)):
    output.append([labelList[i][0],sector[i],industry[i]])
a=np.asarray(output)
np.savetxt("~/Documents/Bids and Proposals/USCIS/sector_industry.csv",a,delimiter=",", fmt='%s')


#find centroid for each sector/industry
a
arr_classification = []
for i in range(0,len(a)):
    arr_classification.append([a[i][0],int(a[i][1]]),int(a[i][2]]))
df_output=pd.DataFrame(data=a,columns=['ind','sector','industry'])

arr_doc2vec=[]
for i in range(0,len(labelList)):
    arr =[]
    arr.append(labelList[i][0])
    for j in range(0,len(data[i])):
        arr.append(data[i][j])
    arr_doc2vec.append(arr)

colname_doc2vec=['ind']
for i in range(1,len(data[i])+1):
    colname_doc2vec.append("V"+str(i))

df_doc2vec=pd.DataFrame(data=arr_doc2vec,columns=colname_doc2vec)
df_doc2vec=pd.merge(df_doc2vec,df_output,how='left',on='ind')
df_sector_avg=df_doc2vec.groupby('sector').mean()
df_industry_avg=df_doc2vec.groupby('industry').mean()

df_sector_avg.to_csv('~/Documents/Bids and Proposals/USCIS/sector_avg.csv')
df_industry_avg.to_csv('~/Documents/Bids and Proposals/USCIS/industry_avg.csv')

# find each company's distance from each sector/industry
for i in range(0,df_doc2vec.shape[0]):
    
df_doc2vec=
np.linalg.norm()


from boto.s3.connection import S3Connection
conn = S3Connection('AKIAVO5KNXW5D3Q2WOO6','mz0moOQeyYFhQmeN3Db8+UiGlCOXdKMJBZib+2dy')
bucket = conn.get_bucket('gh-mdas-data')
for key in bucket.list():