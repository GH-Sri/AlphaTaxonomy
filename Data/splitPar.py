def splitDF(n=16,inputFile='C:/Users/dmoore002/Documents/TechChallengeUSCIS/data.csv'):
    import pandas as pd
    import numpy as np

    df = pd.read_csv(inputFile)
    ar = np.array_split(df,n)
    counter = 1
    for item in ar:
        dfTemp = pd.DataFrame(item)
        dfTemp.to_csv('C:/Users/dmoore002/Documents/TechChallengeUSCIS/data{}_proc_input.csv'.format(counter),index=False)
        counter += 1
        

splitDF(n=16,inputFile='PATH/10kData.csv')    
    
