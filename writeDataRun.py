import boto3

keyId = 'AKIAVO5KNXW5MLTJ2JOS'
secretId = 'xUJmbLt+sRYTAcKJmsQE3D2r5Z2K1NbYBOit5lHX' 
bucketName = 'at-mdas-data'


s3 = boto3.resource('s3',\
        aws_access_key_id=keyId,\
        aws_secret_access_key=secretId)

BUCKET = bucketName
suffix = '_2018_10K'
inFiles=['sector_industry.csv','competitor_similarity.csv','doc_cossim_industry.csv','doc_cossim_sector.csv','sector_words.csv','industry_words.csv','cleaned_data_agg.csv']
outFiles=['company_sector_industry'+suffix,'competitors'+suffix,'industry_weights'+suffix,'sector_weights'+suffix,'sector_words'+suffix,'industry_words'+suffix,'cleaned_data_agg'+suffix]

for i in range(0,len(inFiles)):
    s3.Bucket(BUCKET).upload_file(inFiles[i], 'Output-For-ETL/'+outFiles[i]+'.csv')

