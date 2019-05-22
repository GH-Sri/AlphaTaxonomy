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
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster, maxdists,ward, average
from scipy.spatial.distance import pdist
from sklearn.metrics.pairwise import cosine_similarity
import csv
import os
#import matplotlib as plt
# get current file path
cwd = os.getcwd()


print('Creating Data')

## input data format: CIK(str), date (str: 'YYYY-MM-DD'), V1,...,V200 (float)
data = []
labelList=[]
file_dir = cwd + "/Documents/GitHub/r-libraries/"
#file_dir = ""
with open(file_dir+"cikVectorsExample1.csv", 'r') as csvfile:
    reader = csv.reader(csvfile)
    next(reader, None)  # skip the headers
    for row in reader:
        labelList.append([row[1],int(row[2][0:4])-1])
        data.append([float(val) for val in row[3:]])

print('Finding distances between nodes')

dist = pdist(data,metric='cosine')
sim = 1-dist
for i in range(0,len(dist)):
    dist[i]=dist[i]**2
linked = ward(dist)

#plt.figure(figsize=(60, 100)) 
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
    output.append([labelList[i][0],labelList[i][1],sector[i],industry[i]])
a=np.asarray(output)
df_output=pd.DataFrame(a,columns=['CIK','Year','Sector','Industry'])
df_output.to_csv("sector_industry.csv")

#find centroid for each sector/industry
print('Finding Cluster Centroids')

arr_doc2vec=[]
for i in range(0,len(labelList)):
    arr =[]
    arr.append(labelList[i][0])
    arr.append(labelList[i][1])
    for j in range(0,len(data[i])):
        arr.append(data[i][j])
    arr_doc2vec.append(arr)

colname_doc2vec=['CIK','Year']
for i in range(1,len(data[i])+1):
    colname_doc2vec.append("V"+str(i))

df_doc2vec=pd.DataFrame(data=arr_doc2vec,columns=colname_doc2vec)
df_doc2vec['Sector']=df_output['Sector']
df_doc2vec['Industry']=df_output['Industry']
df_doc2vec['Sector']=df_doc2vec['Sector'].astype('int32')
df_doc2vec['Sector']=df_doc2vec['Sector'].astype('category')
df_doc2vec['Industry']=df_doc2vec['Industry'].astype('int32')
df_doc2vec['Industry']=df_doc2vec['Industry'].astype('category')

df_sector_avg=df_doc2vec.groupby('Sector').mean()
df_industry_avg=df_doc2vec.groupby('Industry').mean()
df_sector_avg=df_sector_avg.drop(columns="Year")
df_industry_avg=df_industry_avg.drop(columns="Year")


df_sector_avg.to_csv('sector_avg.csv')
df_industry_avg.to_csv('industry_avg.csv')



# find each company's distance from each sector/industry
# sector
arr_doc_dist=[]
arr_val=[]
for index, row in df_doc2vec.iterrows():
    arr_val.append(row.values[2:df_sector_avg.shape[1]+2])
for i in range(0,len(arr_val)):
    a1=[]
    a1.append(labelList[i][0])
    a1.append(labelList[i][1])
    for j in range(0,df_sector_avg.shape[0]):
        a1.append(cosine_similarity(arr_val[i].reshape(1,-1),
                                    df_sector_avg.values[j].reshape(1,-1))[0][0])
    arr_doc_dist.append(a1)
df_doc_dist_sector=pd.DataFrame(arr_doc_dist)
arr_colnames=['CIK','Year']
for i in range(1,df_doc_dist_sector.shape[1]-1):
    arr_colnames.append((i))
df_doc_dist_sector.columns = arr_colnames

# industry
arr_doc_dist=[]
arr_val=[]
for index, row in df_doc2vec.iterrows():
    arr_val.append(row.values[2:df_industry_avg.shape[1]+2])
for i in range(0,len(arr_val)):
    a1=[]
    a1.append(labelList[i][0])
    a1.append(labelList[i][1])
    for j in range(0,df_industry_avg.shape[0]):
        a1.append(cosine_similarity(arr_val[i].reshape(1,-1),
                                    df_industry_avg.values[j].reshape(1,-1))[0][0])
    arr_doc_dist.append(a1)
df_doc_dist_industry=pd.DataFrame(arr_doc_dist)
arr_colnames=['CIK','Year']
for i in range(1,df_doc_dist_industry.shape[1]-1):
    arr_colnames.append((i))
df_doc_dist_industry.columns = arr_colnames

# melt the data frame into long format
df_doc_dist_sector=pd.melt(df_doc_dist_sector,
                           id_vars=list(df_doc_dist_sector.columns)[0:2],
                           value_vars=list(df_doc_dist_sector.columns)[2:],
                           var_name='Sector',
                           value_name='similarity')
df_doc_dist_sector['Sector']=df_doc_dist_sector['Sector'].astype('int32')
df_doc_dist_sector['Sector']=df_doc_dist_sector['Sector'].astype('category')

df_doc_dist_industry=pd.melt(df_doc_dist_industry,
                           id_vars=list(df_doc_dist_industry.columns)[0:2],
                           value_vars=list(df_doc_dist_industry.columns)[2:],
                           var_name='Industry',
                           value_name='similarity')
df_doc_dist_industry['Industry']=df_doc_dist_industry['Industry'].astype('int32')
df_doc_dist_industry['Industry']=df_doc_dist_industry['Industry'].astype('category')


df_doc_dist_sector.to_csv('doc_cossim_sector.csv',index=False)
df_doc_dist_industry.to_csv('doc_cossim_industry.csv',index=False)



