from gensim.models.doc2vec import Doc2Vec
import numpy as np
import pandas as pd

model = Doc2Vec.load('Doc2Vec_Model')
df_sector_avg = pd.read_csv('sector_avg.csv')
df_industry_avg = pd.read_csv('industry_avg.csv')

sector_df = pd.DataFrame(columns=['Sector','Word','Similarity'])

for i in range(df_sector_avg.shape[0]):
    newVec = np.array(df_sector_avg.iloc[i][1:]) # Creates a word embedding for query based on trained model
    
    words = model.wv.most_similar(positive=[newVec],topn=10)
    for word in words:
        sector_df = sector_df.append({'Sector':df_sector_avg.index[i], 'Word':word[0], 'Similarity':word[1]},\
                   ignore_index=True)


industry_df = pd.DataFrame(columns=['Industry','Word','Similarity'])

for i in range(df_industry_avg.shape[0]):
    newVec = np.array(df_industry_avg.iloc[i][1:]) # Creates a word embedding for query based on trained model
    
    words = model.wv.most_similar(positive=[newVec],topn=10)
    for word in words:
        industry_df = industry_df.append({'Industry':df_industry_avg.index[i], 'Word':word[0], 'Similarity':word[1]},\
                   ignore_index=True)


sector_df.to_csv('sector_words.csv',index=False)
industry_df.to_csv('industry_words.csv',index=False)



