import pandas as pd
import sys
num_doc = int(sys.argv[1])
df_table = pd.read_csv('cleaned_data'+str(1)+'.csv')
for i in range(1,num_doc):
    df_table=df_table.append(pd.read_csv('cleaned_data'+str(i)+'.csv'))
df_table.to_csv('cleaned_data_agg.csv')
