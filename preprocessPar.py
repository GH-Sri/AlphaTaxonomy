# -*- coding: utf-8 -*-
"""
Created on Mon May 27 11:56:51 2019

@author: dmoore002
"""

def preprocess(inputFile='data.csv'):
    import nltk
    from nltk import pos_tag
    from nltk.corpus import stopwords
    from nltk.tokenize import word_tokenize
    import re
    from gensim.models.doc2vec import TaggedDocument
    import pandas as pd
    import gensim
    from collections import namedtuple
    


    #bool statements
    rerun_preprocessing = True
    
    if rerun_preprocessing:
        #   Read in docs
        df = pd.read_csv(inputFile)
        #df = df.head(n=200)
        #   Drop NA's 
        df.dropna(subset=['text'],inplace=True)
        
        #   Only use the text for analysis
        allDocs = df['text']
        #   Clean texts
        nltk.download('averaged_perceptron_tagger')
        nltk.download('stopwords')
        nltk.download('punkt')
        def normalize_text(text):
            # subset just to item 1
            if text.find('Item 1A')!=-1:
                text=text[:text.find('Item 1A')]        
            #   Replace breaks with spaces
            normText = text.replace('<br />', ' ')
            #   Remove non-alphabet characters (i.e. numbers)
            normText = re.sub("[^a-zA-Z]+", " ", normText)
            # get rid of stop words
            stop_words = set(stopwords.words('english'))
            word_tokens = word_tokenize(normText)
            word_tokens=[w for w in word_tokens if not w in stop_words]
            word_tokens_tagged=pos_tag(word_tokens)
            # get rid of proper nouns, adverbs, prepositions, determiner, 
            word_tokens_possed=[word for word,pos in word_tokens_tagged if not pos in ['NNP','NNPS','RB','RBR','RBS','IN','DT','PRP','PRP$']]
            #   Join split document back to one continuous doc
            return(' '.join(word_tokens_possed).lower())
        
        
        
        #   Create a list of all of the documents normalized
        
        print('Creating normalized text corpus')
        # end testing
        finDocs = []
        for doc in allDocs:
            finDocs.append(normalize_text(doc))
        
        # save intermediate result
        df_intermediate = df.copy()
        df_intermediate['text']=finDocs
        df_intermediate.to_csv('cleaned_data.csv')
    else:
        df=pd.read_csv('cleaned_data.csv')
        
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
    
    return(df,docList)
    
    

df, docList = preprocess()

fileName = 'firstData'
docName = 'firstDoc'

df.to_csv('{}.csv'.format(fileName))
docList.to_csv('{}.csv'.format(docName))




