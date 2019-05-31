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
SentimentDocument = namedtuple('SentimentDocument', 'words tags split sentiment')

#   Tag the documents  
allTheDocs = []
for index, text in enumerate(finDocsAgg):
    tokens = gensim.utils.to_unicode(text).split()
    words = tokens[:]
    tags = [index]
    if (random.uniform(0,1) < 0.9):
        split = 'train'
    else:
        split = 'test'
    #split = ['train', 'test', 'extra', 'extra'][index//1201]
    sentiment = [1.0, 0.0, 1.0, 0.0, None, None, None, None][index//(len(finDocsAgg)//8 + 1)]
    allTheDocs.append(SentimentDocument(words, tags, split,sentiment))
    
trainDocs = [doc for doc in allTheDocs if doc.split == 'train']
testDocs = [doc for doc in allTheDocs if doc.split == 'test']

print('%d docs: %d train-sentiment, %d test-sentiment' % (len(allTheDocs), len(trainDocs), len(testDocs)))

from random import shuffle
docList = allTheDocs[:]
shuffle(docList)

from gensim.models import Doc2Vec
import gensim.models.doc2vec
from collections import OrderedDict

#DBOW plain
#DM w/default averaging, higher starting alpha improves CBOW PV-DM modles
#DM w/concatenation ??
simpleModels = [\
                Doc2Vec(dm=0, vector_size=200, negative=5, hs=0, min_count=5, sample=0,\
                        epochs=15, workers=4),\
                Doc2Vec(dm=1, vector_size=100, window=10, negative=5, hs=0, min_count=2,\
                        sample=0, epochs=20, workers=4, alpha=0.05),\
                Doc2Vec(dm=1, dm_concat=1, vector_size=100, window=5, negative=5, hs=0,\
                        min_count=2, sample=0, epochs=20, workers=4)]
                
for model in simpleModels:
    model.build_vocab(allTheDocs)
    print("%s vocabulary scanned & state initialized" % model)
    
modelsByName = OrderedDict((str(model), model) for model in simpleModels)

#from gensim.test.test_doc2vec import ConcatenatedDoc2Vec
#modelsByName['dbow+dmm'] = ConcatenatedDoc2Vec([simpleModels[0], simpleModels[1]])
#modelsByName['dbow+dmc'] = ConcatenatedDoc2Vec([simpleModels[0], simpleModels[2]])

model = simpleModels[0]

model.train(docList, total_examples=len(docList), epochs=model.epochs)




##Dataframe construction

ciks = []
for index, value in df['CIK'].iteritems():
    ciks.append(value)

vectors = []
for i in range(len(model.docvecs)):
    vectors.append(model.docvecs[i])
    
right_vec = [[] for i in range(len(vectors[0]))]
for i in range(len(vectors[0])):
    for j in range(len(vectors)):
        right_vec[i].append(vectors[j][i])
        
#List 1 of right_vec == first column of dataframe
        
d = {'ciks':ciks}
counter = 0
for i in right_vec:
    d['col{}'.format(counter)] = i
    counter += 1
        
dfComp = pd.DataFrame.from_dict(d)

dfComp.to_csv('cikVectorsExample1.csv')
    


    
    
##Possible consolidated code################################################


NUM_WORKERS = multiprocessing.cpu_count()
NUM_VECTORS = 500

sentences = list(LabeledSentence(clean_doc(key),
                                 value) for key, value in corpus)
vector_count = NUM_VECTORS
model = Doc2Vec(size=vector_count, min_count=1, dm=0, iter=1,
                dm_mean=1, dbow_words=1, workers=NUM_WORKERS)
model.build_vocab(sentences)

start_alpha = config.start_alpha  # 0.025 by default
alpha_step = config.alpha_step   # 0.001 by default
epochs = config.epochs   # 25 by default

model.alpha = start_alpha

for epoch in range(epochs):
    print ("Training epoch", epoch)
    model.train(sentences)
    model.alpha -= alpha_step
    model.min_alpha = model.alpha
    
###########################################################################


