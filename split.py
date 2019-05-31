import pandas as pd

def splitDF(n=16,inputFile='data.csv'):
    import pandas as pd
    import numpy as np

    df = pd.read_csv(inputFile)
    ar = np.array_split(df,n)
    counter = 1
    for item in ar:
        dfTemp = pd.DataFrame(item)
        dfTemp.to_csv('data{}_proc_input.csv'.format(counter))
        counter += 1
        

splitDF()    
    
