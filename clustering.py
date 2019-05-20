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
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster, maxdists,ward
from scipy.spatial.distance import pdist
import csv
import os
#import matplotlib as plt
# get current file path
cwd = os.getcwd()


print('Creating Data')

data = []
labelList=[]
#file_dir = cwd + "\\Documents\\GitHub\\r-libraries\\"
file_dir = cwd
with open(file_dir+"/cikVectorsExample1.csv", 'r') as csvfile:
    reader = csv.reader(csvfile)
    next(reader, None)  # skip the headers
    for row in reader:
        labelList.append(row[1]+"-"+row[2][0:4])
        data.append([float(val) for val in row[3:]])

print('Finding distances between nodes')

dist = pdist(data)
linked = ward(dist)
#plt.figure(figsize=(35, 50)) 
#dendrogram(linked,  
#            orientation='right',
#            leaf_font_size=12.,
#            labels=labelList,
#            show_leaf_counts=True,
#            color_threshold=maxdists(linked)[::-1][9]
#            )
#plt.show()

# we want to output 
# function labels each instance as cluster #

print('Getting Clusters')

def get_n_clusters(Z, n):
    threshold=maxdists(Z)[::-1][n-1]
    return fcluster(Z,t=threshold,criterion='distance')

print('Labeling Sectors and Industries')

output=[]
sector=get_n_clusters(linked,10)
industry=get_n_clusters(linked,100)
for i in range(0,len(labelList)):
    output.append([labelList[i][0],sector[i],industry[i]])
a=np.asarray(output)
np.savetxt("sector_industry.csv",a,delimiter=",", fmt='%s')


#find centroid for each sector/industry
df_output=pd.DataFrame(data=a,columns=['ind','sector','industry'])

print('Finding Cluster Centroids')

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

df_sector_avg.to_csv('sector_avg.csv')
df_industry_avg.to_csv('industry_avg.csv')



# find each company's distance from each sector/industry
# sector
arr_doc_dist=[]
arr_val=[]
for index, row in df_doc2vec.iterrows():
    arr_val.append(row.values[1:201])
for i in range(0,len(arr_val)):
    a1=[]
    for j in range(0,df_sector_avg.shape[0]):
        a1.append(np.linalg.norm(arr_val[i]-df_sector_avg.values[j]))
    arr_doc_dist.append(a1)

df_doc_dist_sector=pd.DataFrame(arr_doc_dist)
arr_colnames=[]
for i in range(0,df_doc_dist_sector.shape[1]):
    arr_colnames.append('Sector '+str(i+1))
df_doc_dist_sector.columns = arr_colnames

# industry
arr_doc_dist=[]
arr_val=[]
for index, row in df_doc2vec.iterrows():
    arr_val.append(row.values[1:201])
for i in range(0,len(arr_val)):
    a1=[]
    for j in range(0,df_industry_avg.shape[0]):
        a1.append(np.linalg.norm(arr_val[i]-df_industry_avg.values[j]))
    arr_doc_dist.append(a1)
df_doc_dist_industry=pd.DataFrame(arr_doc_dist)
arr_colnames=[]
for i in range(0,df_doc_dist_industry.shape[1]):
    arr_colnames.append('Industry '+str(i+1))
df_doc_dist_industry.columns = arr_colnames

df_doc_dist_sector.to_csv('doc_dist_sector.csv')
df_doc_dist_industry.to_csv('doc_dist_industry.csv')




