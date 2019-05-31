# -*- coding: utf-8 -*-
"""
Created on Mon May 27 11:59:06 2019

@author: dmoore002
"""

#Reads in n number of dataframes
def agg(dataNames=['firstData.csv','secondData.csv'],docsNames=['firstDoc.csv','secondDoc.csv']):
    import pandas as pd
    from collections import namedtuple
    from gensim.models.doc2vec import TaggedDocument
    import gensim


    
    names = dataNames
    df = pd.read_csv(names[0])
    df.dropna(subset=['text'],inplace=True)    
    
    for name in names[1:]:
        dfTemp = pd.read_csv(name)
        df.append(dfTemp)
    
    docNames = docsNames
    dList = pd.read_csv(docNames[0])
    dList.dropna(subset=['text'],inplace=True)
    docs = []
    for index, value in dList['text'].iteritems():
        docs.append(value)
    
    for name in docNames[1:]:
        dListTemp = pd.read_csv(name)
        dListTemp.dropna(subset=['text'],inplace=True)    
        for index, value in dListTemp['text'].iteritems():
            docs.append(value)
    
    #   Create a namedtuple for tagging
    Document = namedtuple('Document', 'words tags')
    
    #   Tag the documents  
    allTheDocs = []
    for index, text in enumerate(docs):
        tokens = gensim.utils.to_unicode(text).split()
        words = tokens[:]
        tags = [index]
        allTheDocs.append(Document(words, tags))
    
    #   Randomly shuffle the documents around in the corpus 
    from random import shuffle
    docList = allTheDocs[:]
    shuffle(docList)
    
    return(df,docList)
    
    
data,docs = agg()


def d2v(data,docs):
    #   Import Doc2Vec modules
    from gensim.models import Doc2Vec
    import gensim.models.doc2vec
    from collections import OrderedDict
    import pandas as pd
    import os
    
    #   Initialize model parameters
    print('Initializing Doc2Vec model')
    model = Doc2Vec(dm=0, vector_size=50, negative=5, hs=0, min_count=5, sample=0,\
                    epochs=15, workers=4)
    
    #   Build model vocabulary from corpus
    print('Building model vocabulary from corpus')
    model.build_vocab(docs)
    
    #   Train model
    print('Training model')
    model.train(docs, total_examples=len(docs), epochs=model.epochs)
    
    
    ##  Dataframe construction
    print('Creating output dataframe')
    ciks = []
    for index, value in data['CIK'].iteritems():
        ciks.append(value)
        
    dates = []
    for index, value in data['YearDate'].iteritems():
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
    vecFile = 'cikVectors.csv'
    dfComp.to_csv(vecFile,index=False)
    
    print('{} sent to: {}'.format(vecFile,os.getcwd()))
    
    #   Save trained model
    modelFile = 'Doc2Vec_Model'
    model.save(modelFile,index=False)

    print('{} sent to: {}'.format(modelFile,os.getcwd()))
    
    
d2v(data)


