# -*- coding: utf-8 -*-
"""
Created on Wed Feb 20 08:31:29 2019

@author: dmoore002
"""

#   Import packages for analysis
import pandas as pd
import re
import string
import gensim
from gensim.models.doc2vec import TaggedDocument
from collections import namedtuple
import random
import time
import re


#   Read in docs
df = pd.read_csv('data.csv')

#   Drop NA's 
df.dropna(subset=['text'],inplace=True)

#   Only use the text for analysis
allDocs = df['text']

#   Convert text to lowercase and strip punctuation/symbols from words
def normalize_text(text):
    normText = text.lower()
    #   Replace breaks with spaces
    normText = normText.replace('<br />', ' ')
    #   Remove non-alphabet characters (i.e. numbers)
    normText = re.sub("[^a-zA-Z]+", " ", normText)
    #   Remove punctuation
    punctuations = "?:!.,;#@"
    #   Strip blank spaces
    split = [item for item in re.split("(\W+)", normText) if len(item) > 0]
    strip = [item.strip(' ') for item in split]
    punc = [item for item in strip if item not in punctuations]
    #   Join split document back to one continuous doc
    return(' '.join(punc))

#   Create a list of all of the documents normalized

print('Creating normalized text corpus')

finDocs = []
for doc in allDocs:
    finDocs.append(normalize_text(doc))

#   Aggregate the documents to remove duplicates
finDocsAgg = finDocs

print('Tagging documents')
#   Create a namedtuple for tagging
Document = namedtuple('Document', 'words tags')

#   Tag the documents  
allTheDocs = []
for index, text in enumerate(finDocsAgg):
    tokens = gensim.utils.to_unicode(text).split()
    words = tokens[:]
    tags = [index]
    allTheDocs.append(Document(words, tags))

#   Randomly shuffle the documents around in the corpus 
from random import shuffle
docList = allTheDocs[:]
shuffle(docList)

#   Import Doc2Vec modules
from gensim.models import Doc2Vec
import gensim.models.doc2vec
from collections import OrderedDict

#   Initialize model parameters
print('Initializing Doc2Vec model')
model = Doc2Vec(dm=0, vector_size=200, negative=5, hs=0, min_count=5, sample=0,\
                epochs=15, workers=4)

#   Build model vocabulary from corpus
print('Building model vocabulary from corpus')
model.build_vocab(allTheDocs)

#   Train model
print('Training model')
model.train(allTheDocs, total_examples=len(docList), epochs=model.epochs)


##  Dataframe construction
print('Creating output dataframe')
ciks = []
for index, value in df['CIK'].iteritems():
    ciks.append(value)
    
dates = []
for index, value in df['YearDate'].iteritems():
    dates.append(value)

vectors = []
for i in range(len(model.docvecs)):
    vectors.append(model.docvecs[i])
    
#   Transpose vectors
right_vec = [[] for i in range(len(vectors[0]))]
for i in range(len(vectors[0])):
    for j in range(len(vectors)):
        right_vec[i].append(vectors[j][i])
        
        
d = {'ciks':ciks,'dates':dates}
#   Create column names for every vector column
counter = 0
for i in right_vec:
    d['col{}'.format(counter)] = i
    counter += 1

#   Write dictionary to dataframe
dfComp = pd.DataFrame.from_dict(d)

#   Write dataframe to local csv file
dfComp.to_csv('cikVectorsExample1.csv')

#   Save trained model
model.save('Doc2Vec_Model')


