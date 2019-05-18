# -*- coding: utf-8 -*-
"""
Created on Wed Feb 20 08:31:29 2019

@author: dmoore002
"""

import pandas as pd
import re
import string
import gensim
from gensim.models.doc2vec import TaggedDocument
from collections import namedtuple
import random
import time


#Read in docs

filePath = 'C:\\Users\\dmoore002\\Documents\\TechChallengeUSCIS'
fileName = '\\ExampleFinalData2.csv'
filePathName = filePath + fileName
df = pd.read_csv(filePathName)

df.dropna(subset=['text'],inplace=True)


allDocs = df['text']

#Convert text to lowercase and strip punctuation/symbols from words
def normalize_text(text):
    normText = text.lower()
    #   Replace breaks with spaces
    normText = normText.replace('<br />', ' ')
    #   Remove punctuation
    punctuations = "?:!.,;#@"
    split = [item for item in re.split("(\W+)", normText) if len(item) > 0]
    strip = [item.strip(' ') for item in split]
    punc = [item for item in strip if item not in punctuations]
    #final = list(filter(lambda a: a != '', strip))        
    return(' '.join(punc))

#   Create a list of all of the documents normalized

finDocs = []
for doc in allDocs:
    finDocs.append(normalize_text(doc))

#   Aggregate the documents to remove duplicates
finDocsAgg = finDocs


#   Create a namedtuple for tagging
Document = namedtuple('Document', 'words tags')

#   Tag the documents  
allTheDocs = []
for index, text in enumerate(finDocsAgg):
    tokens = gensim.utils.to_unicode(text).split()
    words = tokens[:]
    tags = [index]
    allTheDocs.append(Document(words, tags))
    
from random import shuffle
docList = allTheDocs[:]
shuffle(docList)

from gensim.models import Doc2Vec
import gensim.models.doc2vec
from collections import OrderedDict

model = Doc2Vec(dm=0, vector_size=200, negative=5, hs=0, min_count=5, sample=0,\
                epochs=15, workers=4)

model.build_vocab(allTheDocs)

model.train(allTheDocs, total_examples=len(docList), epochs=model.epochs)


##Dataframe construction

ciks = []
for index, value in df['CIK'].iteritems():
    ciks.append(value)
    
dates = []
for index, value in df['YearDate'].iteritems():
    dates.append(value)

vectors = []
for i in range(len(model.docvecs)):
    vectors.append(model.docvecs[i])
    
right_vec = [[] for i in range(len(vectors[0]))]
for i in range(len(vectors[0])):
    for j in range(len(vectors)):
        right_vec[i].append(vectors[j][i])
        
#List 1 of right_vec == first column of dataframe
        
d = {'ciks':ciks,'dates':dates}
counter = 0
for i in right_vec:
    d['col{}'.format(counter)] = i
    counter += 1
        
dfComp = pd.DataFrame.from_dict(d)

dfComp.to_csv('cikVectorsExample1.csv')
