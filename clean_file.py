# -*- coding: utf-8 -*-
"""
Created on Wed May 22 14:27:21 2019

@author: echo001
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
import nltk
from nltk import pos_tag
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
import sys
print ("job number : ", sys.argv)


# run number
run_number = sys.argv[1]
# bool statements
# set as True if you want to re run the text preprocessing step (it takes a very long time)
rerun_preprocessing = True

if rerun_preprocessing:
    #   Read in docs
    df = pd.read_csv('data2018_subset.csv')
    #   Drop NA's 
    df.dropna(subset=['Text'],inplace=True)
    
    #   Only use the text for analysis
    allDocs = df['Text']
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
    if run_number!=16:
        before=int(df.shape[0]/16)*(int(run_number)-1)
        ind=int(df.shape[0]/16)*int(run_number)
        allDocs=allDocs[before:ind]
        df_intermediate = df[before:ind].copy()
    
    if run_number ==16:
        ind=int(df.shape[0]/16)*int(run_number)
        df_intermediate = df[ind:].copy()
        allDocs=allDocs[ind:]
    
    print('Creating normalized text corpus')
    finDocs = []
    for doc in allDocs[:ind]:
        finDocs.append(normalize_text(doc))
    
    # save intermediate result
    df_intermediate['Text']=finDocs
    df_intermediate.to_csv('cleaned_data'+str(run_number)+'.csv',index=False)
